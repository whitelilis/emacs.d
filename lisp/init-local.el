;; wizard code start here
;; zoo
(setq backup-directory-alist '(("." . "~/back")))


;; rainbow-delimiters-mode is good, add for all
;(global-rainbow-delimiters-mode)

;; slime
(after-load 'slime
  (when (executable-find "ccl")
    (add-to-list 'slime-lisp-implementations
                 '(ccl ("ccl") :coding-system utf-8-unix)))
  (setq slime-autodoc-use-multiline-p t)
  (setq slime-default-lisp 'ccl)
  (global-set-key "\C-cs" 'slime-selector))

;;; for time display
(setq display-time-24hr-format t)
(setq display-time-format "%Y-%m-%d %R")
(display-time)

;; auto inster header
(defun my-expand ()
  (beginning-of-buffer)
  (replace-regexp "%@" ""  ))
(add-hook 'find-file-hook 'auto-insert) ;;; Adds hook to find-files-hook
(setq auto-insert-directory "~/.emacs.d/templates/") ;;; Or use custom, *NOTE* Trailing slash important
(setq auto-insert-query nil) ;;; If you don't want to be prompted before insertion
(setq auto-insert-alist '(;; file-name-regexp  description    template-file   other-function-to-do-with-space
                          (("\\.py" . "python file") . ["t.py" my-expand])
                          (("\\-b.org" . "beamer file") . ["b.org" my-expand])
                          (("\\.org" . "org file") .   ["t.org" my-expand])
                          ))



;;; for perl mode
(defalias 'perl-mode 'cperl-mode)
(add-hook 'cperl-mode-hook 'n-cperl-mode-hook t)
(defun n-cperl-mode-hook ()
  (paredit-mode)
  (setq cperl-indent-level 8)
  (setq cperl-continued-statement-offset 0)
;  (setq cperl-extra-newline-before-brace t)
;  (set-face-background 'cperl-array-face "blue")
;  (set-face-background 'cperl-hash-face "red")
  )


;;; frenquency used command in slime repl
(defun change-pr ()
  (interactive)
  (slime-repl-previous-input)
  (paredit-backward)
  (paredit-wrap-sexp))
(global-set-key [(control x) (w)]  'change-pr)

;;; font
(if *is-a-mac*
    (progn
      ;; font for mac
      (set-frame-font "Monaco:pixelsize=15")
      (dolist (charset '(han kana symbol cjk-misc bopomofo))
        (set-fontset-font (frame-parameter nil 'font)
                          charset
                          (font-spec :family "Hiragino Sans GB" :size 18))))
  ;; font for linux
  ;;(set-default-font "文泉驿等宽微米黑-11")
  ;;(set-face-attribute 'default nil :font "文泉驿等宽微米黑-11") ; very good width

  ;; other option 1
  ;;(set-face-attribute 'default nil :font "Monaco-12")  ; good for programming
  ;; other option 2
  ;;(set-face-attribute 'default nil :height 120) ; The value is in 1/10pt, so 100 will give you 10pt, etc.

  ;; org chinese and english table width align good
  (set-default-font "Dejavu Sans Mono 11")
  (dolist (charset '(kana han symbol cjk-misc bopomofo))
    (set-fontset-font (frame-parameter nil 'font)
                      charset
                      (font-spec :family "WenQuanYi Micro Hei Mono" :size 18)))
  )


;;; org export to html, no sub-superscripts
(eval-after-load 'org
  '(progn
     (setq org-mobile-directory "~/Dropbox/orgs")
     (setq org-directory org-mobile-directory)
     (defun org-f (path)
       (concat org-directory "/" path))
     (setq org-mobile-use-encryption t)
     (setq org-agenda-start-with-log-mode t)
     (define-key global-map "\C-cc" 'org-capture)
;     (setq org-default-notes-file (org-f "tasks.org"))

     (setq org-todo-keyword-faces
           '(("TODO" . org-warning)
             ("STARTED" . "yellow")
             ("DONE" . org-done)
             ("SOMEDAY" . "green")
             ("CANCELED" . (:foreground "blue" :weight bold))))

     (setq org-capture-templates
           '(("t" "Todo" entry (file+datetree (org-f "gtd.org"))
              "* TODO [#%^{property|B|A|C}]  %?\n  %i\n")
             ("w" "Waiting" entry (file+datetree (org-f "gtd.org"))
              "* WAITING [#%^{property|B|A|C}]  %?\n %^t\n %i\n")
             ("i" "Idea/someday" entry (file+datetree (org-f "gtd.org"))
              "* SOMEDAY [#C] %?\n")))

     ;; only use file::linenumber link to exactly go to where I want, change from
     ;; http://lists.gnu.org/archive/html/emacs-orgmode/2012-02/msg00706.html
     (defun org-file-lineno-store-link()
       (let* ((link (format "file:%s::%d" (buffer-file-name)
                            (line-number-at-pos))))
         (org-store-link-props
          :type "file"
          :link link)))
     ;(setq org-store-link-functions (list 'org-file-lineno-store-link))
     (defun lineno-goto (open-store-arg)
       (message "length:%s" open-store-arg)
       (goto-line (string-to-int open-store-arg)))
     ;; use the same simple line goto function
     ;(setq org-execute-file-search-functions (list 'lineno-goto))
     ;; end lineno hack

     ;; for month/week report
     ;; study from http://jcardente.blogspot.com/2010/06/org-mode-hack-tasks-done-last-month.html
     (defun wizard/closed-tasks-between (start end)
       (org-tags-view nil
                      (concat
                       "TODO=\"DONE\""
                       (format "+CLOSED>=\"[%s]\"" start)
                       (format "+CLOSED<=\"[%s]\"" end))))
     (defun last-n-day (days)
       (list (format-time-string "%Y-%m-%d" (time-subtract (current-time) (days-to-time days)))
             (format-time-string "%Y-%m-%d" (time-add      (current-time) (days-to-time 1)))))
     (defun last-7-day-report (days)
       (interactive (list (read-number "Days:" 6)))
       (apply 'wizard/closed-tasks-between (last-n-day days)))
     ;; end report stuff

     (setq org-use-sub-superscripts nil)
     (setq org-export-with-toc nil)))

(setq org-agenda-files (list "~/Dropbox/orgs/gtd.org"))
(setq org-return-follows-link t)


;;; rebind
(global-set-key [(control s)] '(lambda ()
                                 "For easy search, eg C-s C-w"
                                 (interactive)
                                 (backward-word)
                                 (isearch-forward)))
(global-set-key [(f5)] 'query-replace-regexp)
(global-set-key [(f8)] 'magit-status)
(global-set-key [(control f8)] 'magit-log)


(setq hippie-expand-try-functions-list
      '(
        try-expand-dabbrev
        try-expand-dabbrev-visible
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill
        try-expand-list
        try-expand-list-all-buffers
        try-expand-line-all-buffers
        try-expand-line
        try-complete-file-name-partially
        try-complete-file-name
        try-expand-all-abbrevs
        try-complete-lisp-symbol-partially
        try-complete-lisp-symbol
        try-expand-whole-kill
        senator-try-expand-semantic
;;;         senator-complete-symbol
;;;         semantic-ia-complete-symbol
        ispell-complete-word))
(global-set-key [(control tab)] 'hippie-expand) ;hippie-expand is very good

;; clear spaces
(add-hook 'before-save-hook 'whitespace-cleanup)

;; processing
(setq processing-location "/Applications/Processing2.app/Contents/MacOS/Processing")
(provide 'init-local)
