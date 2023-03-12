CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

#Clone the repository of the student submission to a well-known directory name (provided in starter code)

rm -rf student-submission
#Wanted to clean up output of clone, used help from StackOverflow
git clone --progress $1 student-submission 2> clone-output.txt
mv clone-output.txt student-submission/clone-output.txt
echo
echo 'Finished cloning'
echo

#Check that the student code has the correct file submitted. If they didn’t, detect and give helpful feedback about it.

cd student-submission
if [[ -e ListExamples.java ]]
then
    echo "ListExamples.java found"
    echo
else
    echo "Error: could not find ListExamples.java"
    LOOKUP=`find . -name "ListExamples.java"`
    if [[ $LOOKUP == *ListExamples.java* ]]
    then
        echo "Found file at: $LOOKUP" 
        echo "ListExamples should be out of any nested directories"
    fi
    echo
    exit
fi

#Check for expected method signatures

CODE=`cat ListExamples.java`
if [[ $CODE == *static?List?String??filter?List?String?*,?StringChecker* ]]
then
    echo 'filter() method found'
else
    echo 'Could not find method: static List<String> filter(List<String> s, StringChecker sc)'
    echo
    exit
fi
if [[ $CODE == *static?List?String??merge?List?String?*,?List?String?* ]]
then
    echo 'merge() method found'
else
    echo 'Could not find method: static List<String> merge(List<String> list1, List<String> list2)'
    echo
    exit
fi
echo

#Somehow get the student code and your test .java file into the same directory

cp ../GradeServer.java ./
cp ../TestListExamples.java ./
cp -r ../lib ./
cp ../Server.java ./

#Compile your tests and the student’s code from the appropriate directory with the appropriate classpath commands. 
#If the compilation fails, detect and give helpful feedback about it.

javac -cp $CPATH *.java 2>javac-errors.txt
if [[ $? -ne 0 ]]
then
    echo Could not Compile
    cat javac-errors.txt
    exit
fi

#Run the tests and report the grade based on the JUnit output.

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples >junit-results.txt
RESULT=`cat junit-results.txt`

if [[ $RESULT == *OK* ]]
then
    echo All Tests Passed!
    echo SCORE: 100%
    echo
    echo Assignment PASSED
    echo
    exit
fi

TESTS_RUN=`grep -o 'Tests run: [[:digit:]]\+' junit-results.txt | grep -o '[[:digit:]]\+'`
TESTS_FAILED=`grep -o 'Failures: [[:digit:]]\+' junit-results.txt | grep -o '[[:digit:]]\+'`

PASSED=$(( $TESTS_RUN - $TESTS_FAILED ))
SCORE=$(( $PASSED * 100 / $TESTS_RUN))
echo
echo SCORE = $SCORE% \($PASSED/$TESTS_RUN\)


if [[ $RESULT  == *FAILURES!* ]]
then
    echo
    echo Failures Found in Tester:
    grep '[[:digit:]]\+) ' junit-results.txt
    echo
    echo Assignment failed
fi
echo
