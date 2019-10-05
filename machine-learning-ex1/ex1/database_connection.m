function  db_conn  = database_connection( dbName)

    % see documentation below for differences between various drivers
    % http://www.mathworks.com/help/database/ug/connecting-to-a-database-using-the-native-odbc-interface.html#bt1ihqi-1

    % How to use Oracle JDBC Driver

    % Note: renaming oracle install directory (client_1) is sometimes very difficult. It's advised that you do not rename these directories.
    %
    % Step 1. Ensure JDBC driver for Oracle (ojdbc6.jar) is installed. IT installs this by default at C:\oracle\product\11.2.0\client_1\jdbc
    %
    % Step 2. Ensure JDBC driver can be found by Matlab Java Runtime
    %         Edit: C:\Users\maengi\AppData\Roaming\MathWorks\MATLAB\R2014b\javaclasspath.txt (can be checked by Matlab command: prefdir)
    %         Add: C:\oracle\product\11.2.0\client_1\jdbc\lib\ojdbc6.jar
    %         To check if this worked, restart Matlab and issue javaclasspath command. ojdbc6.jar must be in the list.
    %
    % Step 3. Ensure that ocijdbc11.dll is discoverable in java.library.path. 
    %         Check your java.library.path with this Matlab command: java.lang.System.getProperty('java.library.path')
    %         If Oracle BIN directory is not there, you have to edit this file and add there
    %         Edit C:\Program Files\MATLAB\R2014b\toolbox\local\librarypath.txt
    %         Add: C:\oracle\product\11.2.0\client_1\BIN
    %
    % Step 4. Ensure that ocijdbc11.dll can find other Oracle dependencies (DLLs)
    %         You have to add oracle binary directory to windows system PATH
    %         E.g. C:\oracle\product\11.2.0\client_1\BIN;
    %
    % Step 5. tns_admin needs to be set correctly
    %         IT should have set tns_admin environment variable to \\invapps\apps\7800\TNSNames
    %
    
    
    setdbprefs('DefaultRowPrefetch', '1000');

    % turn off this particular warning
    % "Unable to fetch in batches: Batch size specified was larger than the number of rows fetched"
    warning('off', 'database:cursor:fetchInBatchesWarning') 

    %db_conn = database('EDBPROD', '',''); % via an JDBC/ODBC Bridge Driver; slow not recommended
    
    %db_conn = database('EDBPROD', '','','Vendor', 'Oracle', 'URL', 'jdbc:oracle:oci:@EDBPROD'); % via JDBC driver (this nicer syntax works in Matlab2014. but it doesn't work in older Matlab)
    
    db_conn = database(dbName, '', '', 'oracle.jdbc.driver.OracleDriver',sprintf('jdbc:oracle:oci:@%s', dbName)); % uses JDBC (better. this syntax works for Matlab2011-2014) 
        
    if (db_conn.Handle == 0)
        disp('Database connection failed');
        disp(db_conn.Message);
        ME = MException('database:MissingDriver',db_conn.Message);
        throw(ME);
    end
    
end

% test query
%sql = ['SELECT * FROM  taafo.view_gsi_trades book WHERE Taafo.Gsi_Timestamp_To_Date(Book.datetime) = TO_DATE(''05/04/2015'', ''mm/dd/yyyy'') '];
%rs = exec(db_conn, sql);
%data = fetch(rs);
%data = data.Data;