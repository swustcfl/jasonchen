
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
;;-----------------------------org end------------------------------------------

;;配置nilsdeppe
;;安装的包需要在这里写上不然会提示包没有
;;melpa-include-packages 变量定义在init-elpa.el中
(setq  melpa-include-packages
       (append  melpa-include-packages
                '(clang-format
                  modern-cpp-font-lock
                  google-c-style
                  magit)))
(require-init 'init-nilsdeppe)

;;---------------------------find file in project -----------------------------
;;项目涉及很多git仓库，所以要ffip-project-root要统一到最上层
(defun jc-project-root ()
  (when (f-descendant-of-p (buffer-file-name) (file-truename "~/Documents/justalk/justalk"))
      (setq-local ffip-project-root (file-truename "~/Documents/justalk/justalk")))
  )
(add-hook 'prog-mode-hook 'jc-project-root)
;;---------------------------find file in project -----------------------------

(provide 'init-jasonchen)