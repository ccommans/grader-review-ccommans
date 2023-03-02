CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

#Clone the repository of the student submission to a well-known directory name (provided in starter code)

rm -rf student-submission
git clone --progress $1 student-submission 2> clone-output.txt #output redirection helped with StackOverflow
echo
echo 'Finished cloning'
echo

#Check that the student code has the correct file submitted. If they didn’t, detect and give helpful feedback about it.
#Useful tools here are if and -e/-f. You can use the exit command to quit a bash script early.

cd student-submission
if [[ -e ListExamples.java ]]
then
    echo "ListExamples.java found"
    echo
else
    echo "Error: could not find ListExamples.java"
    LOOKUP=`find ./ -name "ListExamples.java"`
    if [[ $LOOKUP == *ListExamples.java* ]]
    then
        echo found ListExamples at: $LOOKUP, should be not be in nested directory
    fi
    echo
    exit
fi

CODE=`cat ListExamples.java`
if [[ $CODE == *static?List?String??filter?List?String?*,?StringChecker* ]]
then
    echo 'filter() method found'
else
    echo 'Could not find method: static List<String> filter(List<String> s, StringChecker sc)'
    exit
fi
if [[ $CODE == *static?List?String??merge?List?String?*,?List?String?* ]]
then
    echo 'merge() method found'
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
#TESTS_RUN=`grep -o "(?<=Tests run: )\d+" junit-results.txt`
#echo $TESTS_RUN
if [[ $RESULT == *OK* ]]
then
    echo All Tests Passed!
    echo SCORE: 100
    echo
    echo Assignment PASSED
    exit
fi

grep 'Tests run: \d' junit-results.txt > tests-run.txt
TESTS_RUN=`grep -o -m 1 '[[:digit:]]' tests-run.txt | head -1`

grep 'Failures: \d' junit-results.txt > tests-failed.txt
TESTS_FAILED=`grep -o -m 1 '[[:digit:]]' tests-failed.txt | head -1`

PASSED=$(( $TESTS_RUN - $TESTS_FAILED ))
TOTAL=$(( $TESTS_RUN + $TESTS_FAILED ))

SCORE=$(( $PASSED / $TOTAL * 100 ))
echo
echo SCORE = $SCORE \($PASSED/$TOTAL\)


if [[ $RESULT  == *FAILURES!* ]]
then
    echo
    echo Failures Found in Tester:
    grep ") " junit-results.txt
    echo
    echo Assignment FAILED
fi
echo

