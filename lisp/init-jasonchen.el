
;; 为了org中表格的中英文对齐
(defun spacemacs//set-monospaced-font (english chinese english-size chinese-size)
  (set-face-attribute 'default nil :font
                      (format   "%s:pixelsize=%d"  english english-size))
  (dolist (charset '(kana han cjk-misc bopomofo))
    (set-fontset-font (frame-parameter nil 'font) charset
                      (font-spec :family chinese :size chinese-size))))
;;-----------------------------org begin----------------------------------------
;; 设置org相关
;; 设置字体集和face的想法来自http://zcodes.net/2016/08/22/emacs-notes-config.html
;; https://github.com/zcodes/emacs.d/blob/7d15ef5793a5f1d2f89aa3277639aa1ed89a9ff0/lisp/zcodes-org.el

;;这个是单单对org的table产生影响的设置
;;FIXBUG
(defun jc-org-zh-en-aligned-table ()
  (interactive)

  ;;创建字体集合，ascii码使用 source code pro ，中文使用hiragino
  (setq fontset-orgtable (create-fontset-from-ascii-font "Source Code Pro-14"))
  (dolist (charset '(kana han cjk-misc bopomofo))
    (set-fontset-font fontset-orgtable charset
                      (font-spec :family  "Hiragino Sans GB" :size 16)))

  ;;设置org-table的face属性
  (set-face-attribute 'org-table nil :font
                      (format   "%s:pixelsize=%d"  "Source Code Pro"  14)
                      :fontset fontset-orgtable)
  )

;;生效这个org的整个buffer
(defun jc-org-zh-en-aligned-buffer ()
  (interactive)

  ;;创建一个字体集，这个字体集合，中文字符集的话使用Hiragino Sans GB
  (setq fontset-org (create-fontset-from-ascii-font "Source Code Pro-14"))
  (dolist (charset '(kana han cjk-misc bopomofo))
    (set-fontset-font fontset-org charset
                      (font-spec :family  "Hiragino Sans GB" :size 16)))

  ;;创建face，这个字体集合使用上面
  (make-face 'jc-org-faceset)
  (set-face-attribute 'jc-org-faceset nil :font
                      (format   "%s:pixelsize=%d"  "Source Code Pro"  14)
                      :fontset fontset-org)
 
  ;;生效某个buffer使用特定face
  (buffer-face-mode t)
  (buffer-face-set 'jc-org-faceset)
  )

;;加载org生效
(add-hook 'org-mode-hook 'jc-org-zh-en-aligned-buffer)

;;设置plantuml
(setq org-babel-load-languages
      '((plantuml . t)
        (emacs-lisp . t)))
(org-babel-do-load-languages 'org-babel-load-languages org-babel-load-languages)
(setq org-plantuml-jar-path
      (expand-file-name "~/Downloads/plantuml.jar"))
;;-----------------------------org end------------------------------------------

;;配置nilsdeppe
;;安装的包需要在这里写上不然会提示包没有
;;melpa-include-packages 变量定义在init-elpa.el中
(setq  melpa-include-packages
       (append  melpa-include-packages
                '(clang-format
                  modern-cpp-font-lock
                  google-c-style
                  magit
                  logview
                  zoom
                  go-gen-test
                  company-go
                  flycheck-golangci-lint)))
(require-init 'init-nilsdeppe)

;;---------------------------find file in project -----------------------------
;;项目涉及很多git仓库，所以要ffip-project-root要统一到最上层
(defun jc-project-root ()
  (condition-case var
      (when (f-descendant-of-p (buffer-file-name) (file-truename "~/Documents/justalk/justalk"))
        (setq-local ffip-project-root (file-truename "~/Documents/justalk/justalk")))
    ('error
     (message "func:%s buffer-file-name:%s error: %s" (symbol-name 'jc-project-root) buffer-file-name var)))
  )
(add-hook 'prog-mode-hook 'jc-project-root)
;;---------------------------find file in project -----------------------------

;;--------------------------logview--------------------------------------------
;;配置logview用来看终端日志
;;https://github.com/doublep/logview
;;https://writequit.org/articles/working-with-logs-in-emacs.html
;;在custom-set-variables.el增加Juphoon日志配置,也可以直接从配置C-c C-s进入配置，配置好保存。
;;(custom-set-variables
;; '(logview-additional-level-mappings
;;    (quote
;;     (("JuphoonLevel"
;;       (error "ERROR:")
;;       (warning "WARN:")
;;       (information "INFO:")
;;       (debug "DEBUG:")
;;       ))))
;;  '(logview-additional-submodes
;;    (quote
;;     (("Juphoon"
;;       (format . "TIMESTAMP NAME: LEVEL IGNORED MESSAGE")
;;       (levels . "JuphoonLevel")
;;       (timestamp "JuphoonTime")
;;       (aliases)))))
;;  '(logview-additional-timestamp-formats (quote (("JuphoonTime" (regexp . "\\w+:.*\\+\\w+")))))
;;)

(use-package logview
  :ensure t
  :mode ("\\.log\\'" . logview-mode)
  :config
;; {{ specify major mode uses Evil (vim) NORMAL state or EMACS original state.
;; You may delete this setup to use Evil NORMAL state always.
  (evil-set-initial-state 'logview-mode 'emacs))
;;--------------------------logview--------------------------------------------

;;--------------------------zoom--------------------------------------------
;;配置窗口布局
;;https://github.com/cyrus-and/zoom
;;设置黄金分割线'(0.618 . 0618)
(use-package zoom
  :ensure t
  :init
  (setq zoom-mode 't)
  (setq zoom-size '(0.618 . 0.618))
  :bind ("C-x +" . zoom-mode))
;;--------------------------zoom--------------------------------------------

;;--------------------------go--------------------------------------------
(defvar go-tab-width 4
  "Set the `tab-width' in Go mode. Default is 4.")

(defvar go-format-before-save nil
  "Use gofmt before save. Set to non-nil to enable gofmt before saving. Default is nil.")

(defvar go-use-gometalinter nil
  "Use gometalinter if the variable has non-nil value.")

(defvar go-use-golangci-lint nil
  "Use golangci-lint if the variable has non-nil value.")

;;配置
(eval-after-load 'exec-path-from-shell
  '(progn
     (when (memq window-system '(mac ns))
       (exec-path-from-shell-initialize)
       (exec-path-from-shell-copy-env "GOPATH"))))

(setq go-format-before-save t)

(setq go-use-gometalinter nil)
(setq go-use-golangci-lint t)

(require-init 'init-go)

;;--------------------------go--------------------------------------------

(provide 'init-jasonchen)