<%@ page import="java.sql.*" %>
<html>

<body>
    <table border="1">
        <tr>
            <td valign="top">
                <%-- -------- Include menu HTML code -------- --%>
                <jsp:include page="menu.html" />
            </td>
            <td>

            <%-- Set the scripting language to Java and --%>
            <%-- Import the java.sql package --%>
            <%@ page language="java" import="java.sql.*" %>
    
            <%-- -------- Open Connection Code -------- --%>
            <%
                try {
                    DriverManager.registerDriver
                        (new com.microsoft.sqlserver.jdbc.SQLServerDriver());
    
                    // Make a connection to the Oracle datasource "cse132b"
                    Connection conn = DriverManager.getConnection
                        ("jdbc:sqlserver://LENOVO-PC\\SQLEXPRESS:1433;databaseName=db2","sa","password1");

            %>

            <%-- -------- INSERT Code -------- --%>
            <%
                    String action = request.getParameter("action");
                    // Check if an insertion is requested
                    if (action != null && action.equals("insert")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // INSERT the student attributes INTO the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO Student VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");

                        pstmt.setInt(
                            1, Integer.parseInt(request.getParameter("SSN")));
                        pstmt.setString(2, request.getParameter("STUDENTID"));
                        pstmt.setString(3, request.getParameter("FIRSTNAME"));
                        pstmt.setString(4, request.getParameter("MIDDLENAME"));
                        pstmt.setString(5, request.getParameter("LASTNAME"));
                        pstmt.setString(6, request.getParameter("RESIDENCY"));
                        pstmt.setString(7, "B");
                        pstmt.setString(8, request.getParameter("ENROLLED"));
                        pstmt.setString(9, request.getParameter("STARTDATE"));
                        pstmt.setString(10, request.getParameter("ENDDATE"));
                        //add other items depending on undergrad/grad/phd
                        int rowCount = pstmt.executeUpdate();

                        PreparedStatement pstmt2 = conn.prepareStatement(
                            "INSERT INTO Undergrad VALUES (?, ?, ?, ?, ?, ?)"); //" ?, ?)");

                        pstmt2.setString(1, request.getParameter("STUDENTID"));
                        pstmt2.setString(2,request.getParameter("MAJOR"));
                        pstmt2.setString(3,request.getParameter("MINOR"));
                        pstmt2.setString(4, request.getParameter("COLLEGE"));
                        pstmt2.setInt(5, Integer.parseInt(request.getParameter("UNITS")));
                        pstmt2.setString(6, request.getParameter("YEAR"));
                        int rowCount2 = pstmt2.executeUpdate();

                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                    }

            %>

            <%-- -------- UPDATE Code -------- --%>
            <%
                    // Check if an update is requested
                    if (action != null && action.equals("update")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // UPDATE the student attributes in the Student table.
                         PreparedStatement pstmt = conn.prepareStatement(
                            "UPDATE Student SET STUDENTID = ?, FIRSTNAME = ?, " +
                            "MIDDLENAME = ?, LASTNAME = ?, RESIDENCY = ?, ENROLLED = ?, STARTDATE= ?, "
                            + " ENDDATE = ? WHERE SSN = ?");

                        pstmt.setString(1, request.getParameter("STUDENTID"));
                        pstmt.setString(2, request.getParameter("FIRSTNAME"));
                        pstmt.setString(3, request.getParameter("MIDDLENAME"));
                        pstmt.setString(4, request.getParameter("LASTNAME"));
                        pstmt.setString(5, request.getParameter("RESIDENCY"));
                        pstmt.setString(6, request.getParameter("ENROLLED"));
                        pstmt.setString(7, request.getParameter("STARTDATE"));
                        pstmt.setString(8, request.getParameter("ENDDATE"));
                        pstmt.setInt(
                            9, Integer.parseInt(request.getParameter("SSN")));
                        int rowCount = pstmt.executeUpdate();

                        PreparedStatement pstmt2 = conn.prepareStatement(
                            "UPDATE Undergrad SET MAJOR = ?, MINOR = ?, COLLEGE = ?, UNITS = ?, YEAR = ?" +
                            "WHERE STUDENTID = ?");

                      
                    
                        pstmt2.setString(1, request.getParameter("MAJOR"));
                        pstmt2.setString(2, request.getParameter("MINOR"));
                        pstmt2.setString(3, request.getParameter("COLLEGE"));
                        pstmt2.setInt(
                            4, Integer.parseInt(request.getParameter("UNITS")));
                        pstmt2.setString(5, request.getParameter("YEAR"));
                        pstmt2.setString(6, request.getParameter("STUDENTID"));
                        int rowCount2 = pstmt2.executeUpdate();

                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- DELETE Code -------- --%>
            <%
                    // Check if a delete is requested
                    if (action != null && action.equals("delete")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // DELETE the student FROM the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "DELETE FROM Student WHERE STUDENTID = ?");

                        pstmt.setString(1, request.getParameter("STUDENTID"));
                        int rowCount = pstmt.executeUpdate();

                        //PreparedStatement pstmt2 = conn.prepareStatement(
                          //  "DELETE FROM Undergrad WHERE STUDENTID = ?");

                        //pstmt2.setInt(
                          //  1, Integer.parseInt(request.getParameter("STUDENTID")));
                        //int rowCount2 = pstmt2.executeUpdate();

                        // Commit transaction
                         conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the created statement to SELECT
                    // the student attributes FROM the Student table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM Student,Undergrad WHERE Undergrad.studentid = Student.studentid");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>SSN</th>
                        <th>SID</th>
                        <th>First</th>
			            <th>Middle</th>
                        <th>Last</th>
                        <th>Residency</th>
                        <th>Enrolled</th>
                        <th>Start Date</th>
                        <th>End Date</th>
                        <th>Major</th>
                        <th>Minor</th>
                        <th>College</th>
                        <th>Units</th>
                        <th>Year</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="Undergrad.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="SSN" size="10"></th>
                            <th><input value="" name="STUDENTID" size="10"></th>
                            <th><input value="" name="FIRSTNAME" size="15"></th>
			                <th><input value="" name="MIDDLENAME" size="15"></th>
                            <th><input value="" name="LASTNAME" size="15"></th>
                            <th><select name="RESIDENCY">
                                <option value="CA">CA</option>
                                <option value="NON-CA US">NON-CA US</option>
                                <option value="FOREIGN">FOREIGN STUDENT</option>
                              </select></th>
                              <th><select name="ENROLLED">
                                <option value="Yes">Yes</option>
                                <option value="No">No</option>
                              </select></th>
                            <th><input value="" name="STARTDATE" size="15"></th>
                            <th><input value="" name="ENDDATE" size="15"></th>
                            <th><input value="" name="MAJOR" size="15"></th>
                            <th><input value="" name="MINOR" size="15"></th>
                            <th><select name="COLLEGE">
                                <option value="ERC">ERC</option>
                                <option value="MARSHALL">MARSHALL</option>
                                <option value="MUIR">MUIR</option>
                                <option value="REVELLE">REVELLE</option>
                                <option value="SIXTH">SIXTH</option>
                                <option value="WARREN">WARREN</option>
                              </select></th>
                            <th><input value="" name="UNITS" size="15"></th>
                            <th><input value="" name="YEAR" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="Undergrad.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the SSN, which is a number --%>
                            <td>
                                <input value="<%= rs.getInt("SSN") %>" 
                                    name="SSN" size="10">
                            </td>
    
                            <%-- Get theSTUDENTID --%>
                            <td>
                                <input value="<%= rs.getString("STUDENTID") %>" 
                                    name="STUDENTID" size="10">
                            </td>
    
                            <%-- Get the FIRSTNAME --%>
                            <td>
                                <input value="<%= rs.getString("FIRSTNAME") %>"
                                    name="FIRSTNAME" size="15">
                            </td>
    
                            <%-- Get the LASTNAME --%>
                            <td>
                                <input value="<%= rs.getString("MIDDLENAME") %>" 
                                    name="MIDDLENAME" size="15">
                            </td>
    
			    <%-- Get the LASTNAME --%>
                            <td>
                                <input value="<%= rs.getString("LASTNAME") %>" 
                                    name="LASTNAME" size="15">
                            </td>

                            <%-- Get the COLLEGE --%>
                            <td>
                                <input value="<%= rs.getString("RESIDENCY") %>" 
                                    name="RESIDENCY" size="15">
                            </td>
                            <td>
                                <input value="<%= rs.getString("ENROLLED") %>" 
                                    name="ENROLLED" size="15">
                            </td>
                            <td>
                                <input value="<%= rs.getString("STARTDATE") %>" 
                                    name="STARTDATE" size="15">
                            </td>
                            <td>
                                <input value="<%= rs.getString("ENDDATE") %>" 
                                    name="ENDDATE" size="15">
                            </td>
                            <td>
                                <input value="<%= rs.getString("MAJOR") %>" 
                                    name="MAJOR" size="15">
                            </td>
                            <td>
                                <input value="<%= rs.getString("MINOR") %>" 
                                    name="MINOR" size="15">
                            </td>
                            <td>
                                <input value="<%= rs.getString("COLLEGE") %>" 
                                    name="COLLEGE" size="15">
                            </td>
                            <td>
                                <input value="<%= rs.getInt("UNITS") %>" 
                                    name="UNITS" size="15">
                            </td>
                             <td>
                                <input value="<%= rs.getString("YEAR") %>" 
                                    name="YEAR" size="15">
                            </td>
                            
    
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="Undergrad.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getString("STUDENTID") %>" name="STUDENTID">
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Delete">
                            </td>
                        </form>
                    </tr>
            <%
                    }
            %>

            <%-- -------- Close Connection Code -------- --%>
            <%
                    // Close the ResultSet
                    rs.close();
    
                    // Close the Statement
                    statement.close();
    
                    // Close the Connection
                    conn.close();
                } catch (SQLException sqle) {
                    out.println(sqle.getMessage());
                } catch (Exception e) {
                    out.println(e.getMessage());
                }
            %>
                </table>
            </td>
        </tr>
    </table>
</body>

</html>
