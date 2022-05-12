# tf-release

* On pull request to main:
  * runs fmt,init,validate,plan
* On PR merge to main:
  * runs fmt,init,validate,plan and wait for approval before apply
* On pre-release from main:
  * runs fmt,init,validate,plan and wait for approval before apply
* On release from main or promote pre-release to release:
  * runs fmt,init,validate,plan and wait for approval before apply