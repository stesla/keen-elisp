(defvar *keen-select-prefix-map* (make-sparse-keymap))
(define-key *keen-select-prefix-map* "?" 'keen-select-display-bindings)

(defun keen-select-display-bindings ()
  (interactive)
  (describe-bindings keen-select-prefix))

(defmacro keen-select-map-key (key function)
  "Define KEY to run FUNCTION"
  `(define-key *keen-select-prefix-map* ,key ',function))

(defmacro keen-select-define-key (fname-base key &optional buf-form else-form)
  "Define a select-key function FNAME-BASE bound on KEY.

If provided, BUF-FORM should be a form which will attempt to return
a buffer to switch to.  If it returns nil, ELSE-FORM is evaluated."
  (let ((fname (intern (concat "keen-select-" (symbol-name fname-base)))))
    `(progn
       (defun ,fname (arg)
         (interactive "P")
         (let ((buf ,buf-form))
           (if buf
               (switch-to-buffer buf)
             ,else-form)))
       (define-key *keen-select-prefix-map* ,key ',fname))))

(put 'keen-select-define-key 'lisp-indent-function 2)


(defvar *keen-select-keymap* (make-sparse-keymap))
(define-key *keen-select-keymap* [f8] *keen-select-prefix-map*)

;;;###autoload
(define-minor-mode keen-select-mode
  "Keen-Select minor mode. Keybindings to switch to common buffers."
  t
  " select"
  *keen-select-keymap*)

(provide 'keen-select)
