;;-----------------------------company
(require-package 'company-go)
(use-package company-go
  :defer t
  :ensure t
  :init
  (setq company-go-show-annotaion t)
  (add-hook 'go-mode-hook (lambda ()
                          (set (make-local-variable 'company-backends) '(company-go))
                          (company-mode)))
  )

;;-----------------------------flycheck
(defun spacemacs//go-enable-gometalinter ()
   "Enable `flycheck-gometalinter' and disable overlapping `flycheck' linters."
   (setq flycheck-disabled-checkers '(go-gofmt
                                      go-golint
                                      go-vet
                                      go-build
                                      go-test
                                      go-errcheck))
   (flycheck-gometalinter-setup))
(use-package flycheck-gometalinter
  :defer t
  :if go-use-gometalinter
  :ensure t
  :commands spacemacs//go-enable-gometalinter
  :init
  ;;https://github.com/favadi/flycheck-gometalinter/issues/13
  (setq flycheck-gometalinter-deadline "10s")
  (add-hook 'go-mode-hook 'spacemacs//go-enable-gometalinter t))

;;-----------------------------go-eldoc
;;https://github.com/syohex/emacs-go-eldoc
;; TODO gomode中要增加eldoc模式，见spacemacs/ggtags-mode-enable
(use-package go-eldoc
  :ensure t
  :commands go-eldoc-setup
  :init
  (setq go-eldoc-gocode (concat (getenv "GOPATH") "/bin/gocode"))
  (add-hook 'go-mode-hook 'go-eldoc-setup))

;;-----------------------------go-fill-struct
(use-package go-fill-struct
  :defer t
  :ensure t
  :bind
  (( "C-c r s" . go-fill-struct)))

;;-----------------------------go-gen-test
(use-package go-gen-test
  :defer t
  :ensure t
  :bind
  (("C-c t g" . go-gen-test-dwim)
   ("C-c t f" . go-gen-test-exported)
   ("C-c t F" . go-gen-test-all)))

;;-----------------------------go-guru
(use-package go-guru
  :defer t
  :ensure t
  :bind
  (("C-c f <" . go-guru-callers)
   ("C-c f >" . go-guru-callees)
   ("C-c f c" . go-guru-peers)
   ("C-c f d" . go-guru-describe)
   ("C-c f e" . go-guru-whicherrs)
   ("C-c f f" . go-guru-freevars)
   ("C-c f i" . go-guru-implements)
   ("C-c f j" . go-guru-definition)
   ("C-c f o" . go-guru-set-scope)
   ("C-c f p" . go-guru-pointsto)
   ("C-c f r" . go-guru-referrers)
   ("C-c f s" . go-guru-callstack)))

;;-----------------------------go-impl
;;(require-package 'go-impl)
(use-package go-impl
  :defer t
  :ensure t
  :bind 
  (( "C-c r i" . go-impl)))


;;-----------------------------go-mode
(defun spacemacs/go-packages-gopkgs ()
  "Return a list of all Go packages, using `gopkgs'."
  (sort (process-lines "gopkgs") #'string<))

(defun spacemacs//go-set-tab-width ()
  "Set the tab width."
  (when go-tab-width
    (setq-local tab-width go-tab-width)))

(defun spacemacs/go-run-tests (args)
  (interactive)
  (compilation-start (concat "go test " args " " go-use-test-args)
                     nil (lambda (n) go-test-buffer-name) nil))

(defun spacemacs/go-run-package-tests ()
  (interactive)
  (spacemacs/go-run-tests ""))

(defun spacemacs/go-run-package-tests-nested ()
  (interactive)
  (spacemacs/go-run-tests "./..."))

(defun spacemacs/go-run-test-current-function ()
  (interactive)
  (if (string-match "_test\\.go" buffer-file-name)
      (let ((test-method (if go-use-gocheck-for-testing
                             "-check.f"
                           "-run")))
        (save-excursion
          (re-search-backward "^func[ ]+\\(([[:alnum:]]*?[ ]?[*]?[[:alnum:]]+)[ ]+\\)?\\(Test[[:alnum:]_]+\\)(.*)")
          (spacemacs/go-run-tests (concat test-method "='" (match-string-no-properties 2) "$'"))))
    (message "Must be in a _test.go file to run go-run-test-current-function")))

(defun spacemacs/go-run-test-current-suite ()
  (interactive)
  (if (string-match "_test\.go" buffer-file-name)
      (if go-use-gocheck-for-testing
          (save-excursion
            (re-search-backward "^func[ ]+\\(([[:alnum:]]*?[ ]?[*]?\\([[:alnum:]]+\\))[ ]+\\)?Test[[:alnum:]_]+(.*)")
            (spacemacs/go-run-tests (concat "-check.f='" (match-string-no-properties 2) "'")))
        (message "Gocheck is needed to test the current suite"))
    (message "Must be in a _test.go file to run go-test-current-suite")))

(defun spacemacs/go-run-main ()
  (interactive)
  (shell-command
   (format "go run %s"
           (shell-quote-argument (or (file-remote-p (buffer-file-name (buffer-base-buffer)) 'localname)
                                     (buffer-file-name (buffer-base-buffer)))))))

(use-package go-mode
  :defer t
  :ensure t
  :mode ("\\.go\\'" . go-mode)
  :init
    (progn
      ;; get go packages much faster
      (setq go-packages-function 'spacemacs/go-packages-gopkgs)
      (add-hook 'go-mode-hook 'spacemacs//go-set-tab-width)
      (add-hook 'go-mode-local-vars-hook
                #'spacemacs//go-setup-backend)
     )
  :config
    (progn
      (when go-format-before-save
        (add-hook 'before-save-hook 'gofmt-before-save))
      (bind-key "C-c ="  'gofmt)
      (bind-key "C-c e b" 'go-play-buffer)
      (bind-key "C-c e d" 'go-download-play)
      (bind-key "C-c e r" 'go-play-region)
      (bind-key "C-c g a" 'ff-find-other-file)
      (bind-key "C-c g c" 'go-coverage)
      (bind-key "C-c h h" 'godoc-at-point)
      (bind-key "C-c i a" 'go-import-add)
      (bind-key "C-c i g" 'go-goto-imports)
      (bind-key "C-c i r" 'go-remove-unused-imports)
      (bind-key "C-c t P" 'spacemacs/go-run-package-tests-nested)
      (bind-key "C-c t p" 'spacemacs/go-run-package-tests)
      (bind-key "C-c t s" 'spacemacs/go-run-test-current-suite)
      (bind-key "C-c t t" 'spacemacs/go-run-test-current-function) 
      (bind-key "C-c x x" 'spacemacs/go-run-main)))
;;-----------------------------go-rename
(use-package go-rename
  :defer t
  :ensure t
  :bind
  (( "C-c r N" . go-rename)))

;;-----------------------------go-tag
(use-package go-tag
  :defer t
  :ensure t
  :bind
  (("C-c r f" . go-tag-add)
   ("C-c r F" . go-tag-remove)))

;;-----------------------------godoctor
(use-package godoctor
  :defer t
  :ensure t
  :bind
  (("C-c r d" . godoctor-godoc)
   ("C-c r e" . godoctor-extract)
   ("C-c r n" . godoctor-rename)
   ("C-c r t" . godoctor-toggle)))

(provide 'init-go)
