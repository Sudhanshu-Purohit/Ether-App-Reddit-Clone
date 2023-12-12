features folder will contain all the features present in out application
1) auth folder --> this will contain all the authentication part
    a) controller --> this will act as messenger between repository and screens
    b) repository --> this will contain all the calls to database(firebase) it won't have any ui part
    c) screens --> this will contain ui part
    --> screens can directly talk to controller and controller can directly talk to repository and vice versa but screens can not talk directly to repository and vice versa.
    --> repositories will not handle error in the applications all the error in repository will be thrown to controller. controller will handle all the errors.


whenever we use google sign in our flutter application we need to pass the sha1 key
to get the sha1 key --> 
1) go to android folder --> cd android
2) type command --> .\gradlew signingReport
then it will generate the signing report which contains the sha1 and sha256 both keys



if any old fullter project is not running just clean the gradel --> ./gradlew clean