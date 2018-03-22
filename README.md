# banner-comment
Trivial emacs package to format a comment as a banner.  Will reformat
an existing banner.

e.g. Python:

``` python
    # ================================ some text ===============================
```

``` c
    /* ============================== some text ============================= */
```

The only defun provided is `banner-comment`.  Suggested `use-package` initialization:

``` emacs-lisp
(use-package banner-comment
  :commands (banner-comment)
  :bind ("C-c h" . banner-comment))
```
