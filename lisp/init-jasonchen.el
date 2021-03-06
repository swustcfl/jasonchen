
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

;;生效这个org的整个buffer
(defun jc-org-zh-en-aligned-buffer ()
  (interactive)

  ;;创建一个字体集，这个字体集合，中文字符集的话使用Hiragino Sans GB
  ;;SauceCodePro Nerd Font 是通过brew cask 安装的
  (setq fontset-org (create-fontset-from-ascii-font "SauceCodePro Nerd Font-14"))
  (dolist (charset '(kana han cjk-misc bopomofo))
    (set-fontset-font fontset-org charset
                      (font-spec :family  "Hiragino Sans GB" :size 16)))

  ;;创建face，这个字体集合使用上面
  (make-face 'jc-org-faceset)
  (set-face-attribute 'jc-org-faceset nil :font
                      (format   "%s:pixelsize=%d"  "SauceCodePro Nerd Font"  14)
                      :fontset fontset-org)
 
  ;;生效某个buffer使用特定face
  (buffer-face-mode t)
  (buffer-face-set 'jc-org-faceset)
  )

;;加载org生效
(add-hook 'org-mode-hook 'jc-org-zh-en-aligned-buffer)
;;加载markdown生效表格中英文对齐
(add-hook 'markdown-mode-hook 'jc-org-zh-en-aligned-buffer)

;;设置plantuml
(setq org-babel-load-languages
      '((plantuml . t)
        (emacs-lisp . t)))
(org-babel-do-load-languages 'org-babel-load-languages org-babel-load-languages)
(setq org-plantuml-jar-path
      (expand-file-name "~/Downloads/plantuml.jar"))

(require-init 'init-orgmode)

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
;;https://github.com/technomancy/find-file-in-project
;;使用fd来取代find
(setq ffip-use-rust-fd t)
;;自动设置justalk相关sdk路径
;;配置参考的是上面的链接
(defun my-setup-develop-environment ()
  (interactive)
  (when (ffip-current-full-filename-match-pattern-p "\\(lemon\\|avatar\\|giraffe\\|grape\\|jusmeeting\\|melon\\)")
    ;; Though PROJECT_DIR is team's project, I care only its sub-directory "subproj1""
    (setq-local ffip-project-root "~/Documents/justalk/justalk")
    ;; well, I'm not interested in concatenated BIG js file or file in dist/
    (if ffip-use-rust-fd
        ;;(setq-local ffip-find-options "--size -64k --exclude '*/external/*'")
        (setq-local ffip-find-options "--size -64k -E '*test*'")
      ((setq-local ffip-find-options "-not -size +64k -not -iwholename '*/dist/*'")))
    ;; for this project, I'm only interested certain types of files
    ;;(setq-local ffip-patterns '("*.html" "*.js" "*.css" "*.java" "*.xml" "*.js"))
    ;; ignore files whose name match certain glob pattern
    ;; 注释掉是因为默认的ffip-ignore-filenames的值满足需求
    ;;(setq-local ffip-ignore-filenames nil)
    ;; exclude `dist/' directory
    ;;(add-to-list 'ffip-prune-patterns "*/dist")
    )
  ;; insert more WHEN statements below this line for other projects
  )

(add-hook 'prog-mode-hook 'my-setup-develop-environment)
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

(setq go-format-before-save nil)

(setq go-use-gometalinter nil)
(setq go-use-golangci-lint t)

;; 使用gogetdoc来获取文档说明
(setq godoc-at-point-function 'godoc-gogetdoc)

(require-init 'init-go)

;;--------------------------go--------------------------------------------
;;--------------------------emacs-----------------------------------------
;; 打开菜单栏
(menu-bar-mode 1)
;;--------------------------emacs-----------------------------------------
;;--------------------------auto-package-update
;;自动更新的功能
(use-package auto-package-update
  :ensure t
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (setq auto-package-update-interval 14)
  (setq auto-package-update-prompt-before-update t)
  ;; 如果需要立刻更新auto-package-update-now
  (auto-package-update-maybe)
  )
;;--------------------------
;;--------------------------dash
;;使用dash查询文档
;;use-package 在init-nilsdeppe加载的
(use-package use-package-ensure-system-package
  :ensure t)

;;melpa-include-packages 非stable的包要加到这里
(setq  melpa-include-packages
       (append  melpa-include-packages
                '(dash-at-point)))
(use-package dash-at-point
  :ensure t
  :if (eq system-type 'darwin)
  :ensure-system-package
  ("/Applications/Dash.app" . "brew cask install dash")
  :commands dash-at-point
  :init
  (my-comma-leader-def "ds" 'dash-at-point))
;;--------------------------

;;--------------------------snippet
;;生效my-yasnippets路径下的snippet
(defun my-yasnippets-reload ()
  (message "reload ~/my-yasnippets")
  (yas-compile-directory (file-truename "~/my-yasnippets"))
  (yas-reload-all))
(advice-add 'my-yas-reload-all :before #'my-yasnippets-reload)
;;--------------------------


(provide 'init-jasonchen)