CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

#Clone the repository of the student submission to a well-known directory name (provided in starter code)

rm -rf student-submission
git clone $1 student-submission
echo
echo 'Finished cloning'
echo

#Check that the student code has the correct file submitted. If they didn’t, detect and give helpful feedback about it.
#Useful tools here are if and -e/-f. You can use the exit command to quit a bash script early.

cd student-submission
if [[ -e ListExamples.java ]]
then
    echo "ListExamples found"
    echo
else
    echo "Error: could not find ListExamples.java"
    echo
    exit
fi

CODE=`cat ListExamples.java`
if [[ $CODE == *static?List?String??filter?List?String?*,?StringChecker* ]]
then
    echo 'filter() method found'
    echo
else
    echo 'Could not find method: static List<String> filter(List<String> s, StringChecker sc)'
    exit
fi
if [[ $CODE == *static?List?String??merge?List?String?*,?List?String?* ]]
then
    echo 'merge() method found'
    echo
else
    echo 'Could not find method static List<String> merge(List<String> list1, List<String> list2)'
    exit
fi

#Somehow get the student code and your test .java file into the same directory
#Useful tools here might be cp and maybe mkdir

cp ../GradeServer.java ./
cp ../TestListExamples.java ./
cp -r ../lib ./
cp ../Server.java ./

#Compile your tests and the student’s code from the appropriate directory with the appropriate classpath commands. If the compilation fails, detect and give helpful feedback about it.
#Aside from the necessary javac, useful tools here are output redirection and error codes ($?) along with if
#This might be a time where you need to turn off set -e. Why?

javac -cp $CPATH *.java 2>javac-errors.txt
if [[ $? -ne 0 ]]
then
    echo Could not Compile
    cat javac-errors.txt
    exit
fi

#Run the tests and report the grade based on the JUnit output.
#Again output redirection will be useful, and also tools like grep could be helpful here

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples >junit-results.txt
RESULT=`cat junit-results.txt`
if [[ $RESULT  == *FAILURES!* ]]
then
    echo Failures Found:
    grep ") " junit-results.txt

    echo Assignment Failed
else
    echo All Methods Passed!
fi
echo