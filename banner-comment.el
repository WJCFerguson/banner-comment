;;; banner-comment.el --- For producing banner comments
;;
;; Author: James Ferguson <james@faff.org>
;; Version: 2.0
;; Keywords: comment
;;
;;; Commentary:
;;
;; Code to format a line into a banner comment
;;
;;  ;; ================================ like so ================================
;;
;; or in a language with comment-end, like C:
;;
;;  /* =============================== like so ============================== */
;;
;;; Code:

(defgroup banner-comment nil
  "Turning comments into banners."
  :group 'convenience)

(defcustom banner-comment-char ?=
  "Character to be used for comment banners."
  :type 'character)

(defcustom banner-comment-width 80
  "Width for the standard banner."
  :type 'integer)

(defcustom banner-comment-char-match "[[:space:];#/*~=-]*"
  "Regexp to match old comment-banner prefix/suffix text to be destroyed."
  :type 'regexp)

(require 'subr-x) ;; for trim-string


;;;###autoload
(defun banner-comment (&optional end-column)
  "Turn line at point into a banner comment.

Called on an existing banner comment, will reformat it.

Final column may be set by prefix arg END-COLUMN (default 80)."
  (interactive "P")
  (save-excursion
    (save-restriction
      (narrow-to-region (line-beginning-position) (line-end-position))
      (beginning-of-line)
      (if (re-search-forward
           (format
            "^\\([[:space:]]*\\)\\(%s\\|\\)%s\\(.*?\\)%s\\(%s\\|%s\\|\\)$"
            (or comment-start-skip (regexp-quote (string-trim comment-start)))
            banner-comment-char-match
            banner-comment-char-match
            (regexp-quote (string-trim comment-start))
            (regexp-quote (string-trim comment-end))))
          (let* ((central-text (if (string-empty-p (match-string 3))
                                   (make-string 2 banner-comment-char)
                                 (format " %s " (match-string 3))))
                 (banner-char-width (- (or end-column banner-comment-width)
                                       (length (match-string 1)) ;; initial ws
                                       (length comment-start)
                                       (length central-text) ;; actual text
                                       (length comment-end))))
            (replace-match
             (concat
              (match-string 1) ;; initial ws
              comment-start
              (make-string (+ (/ banner-char-width 2) (% banner-char-width 2)) ?=)
              central-text
              (make-string (/ banner-char-width 2) ?=)
              comment-end)))))))


(provide 'banner-comment)
;;; banner-comment.el ends here
