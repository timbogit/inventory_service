# Where are the tests for this code?

## Well ... there are no tests!

### Yeah, yeah, we know ... 
We will go into TDD hell, and all ... but seriously, why are there no tests?

Here are the main reasons:

* These projects will *never* see any production traffic
* We have tested all this manually via some cool ['service explorer' JavaScript UI](http://swagger.wordnik.com)
* The underlying service framework code is well-tested in our production projects
	* much of what you'll see was very much "copty&paste" inspired by LivingSocial code
* we are lazy, and we want to make all of you work for us 
	* adding some tests will be part of the workshop
