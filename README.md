# dbDeploy
gradle database update version control
1. Create '[name].profile' file in 'profiles' folder containing parameters for following keys:

dbDriver, dbUrl, dbUsername, dbPassword, dbDir, dbms, undooutputfile, changelogFile.

(don't put them in any quotation marks).

2. Add property pointing to your 'profiles/[name].profile' file in build.gradle, 'project.ext' (i.e. "mysqllocal = 'profiles/mysqllocal.properties'", "[name] = 'profiles/[name].properties'").

3. Add 'if' block to build.gradle in 'chooseProfile' task setting location of your property file as value to the key 'file'.

4. Run app:
	a. gradle wrapper
	b. gradlew -Pdb=[name] createChangelog - this task will create changelog sql table in your profile folder.
	c. gradlew -Pdb=[name] updateDb - this task will execute not logged before updates from your profile folder.
	All statements should be in .sql files starting from 001.sql, 002.sql,...
