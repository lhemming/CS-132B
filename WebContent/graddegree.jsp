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
                    // Load Oracle Driver class file
                    DriverManager.registerDriver
                        (new com.microsoft.sqlserver.jdbc.SQLServerDriver());
    
                    // Make a connection to the Oracle datasource "cse132b"
                    Connection conn = DriverManager.getConnection
                        ("jdbc:sqlserver://LENOVO-PC\\SQLEXPRESS:1433;databaseName=db2","sa","password1");

            %>

            <%-- -------- INSERT Code -------- --%>
            <%
                    String action = request.getParameter("action");
                    ResultSet rset = null;
                    Statement stmt = null;

                    //resultset =statement.executeQuery("SELECT * FROM COURSE") ;
                    //if( )

                    // Check if an insertion is requested
                    if (action != null && action.equals("insert")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // INSERT the student attributes INTO the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO Degree VALUES (?, ?, ?, ?, ?, ?, ?, ?)"); 

                        pstmt.setString(1, request.getParameter("DEGREEID"));     
                        pstmt.setString(2, request.getParameter("DEPARTMENT"));
                        pstmt.setString(3, request.getParameter("LEVEL"));     // level = undergrad. can be BS or BA (defined in type)
                        pstmt.setString(4, request.getParameter("TYPE"));
                        pstmt.setInt(5, Integer.parseInt(request.getParameter("TOTALUNITS")));
                        pstmt.setString(6, request.getParameter("AVGGRADEREQ"));
                        pstmt.setString(7, request.getParameter("CONCENTRATAION")); // concentrationReq string: null for undergrad degrees
                        /** as a note: eventually we'll need a concentration table. OR can assign a class a "concentration ID" **/
                        pstmt.setString(8, request.getParameter("NAME"));

                        int rowCount = pstmt.executeUpdate();

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
                            "UPDATE Degree SET DEPARTMENT = ?, LEVEL = ?, TYPE = ?, "
                            + "TOTALUNITS = ?, "
                            +"AVGGRADEREQ = ?, CONCENTRATION = ?, NAME = ? WHERE DEGREEID = ?");

                        pstmt.setString(1, request.getParameter("DEPARTMENT"));
                        pstmt.setString(2, request.getParameter("LEVEL"));
                        pstmt.setString(3, request.getParameter("TYPE"));
                        pstmt.setInt(4, Integer.parseInt(request.getParameter("TOTALUNITS")));
                        pstmt.setString(5, request.getParameter("AVGGRADEREQ"));
                        pstmt.setString(6, request.getParameter("CONCENTRATION"));
                        pstmt.setString(7, request.getParameter("NAME"));
                        pstmt.setString(8, request.getParameter("DEGREEID"));

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
                            "DELETE FROM Degree WHERE DEGREEID = ?");

                        pstmt.setString(1, request.getParameter("DEGREEID"));

                        int rowCount = pstmt.executeUpdate();

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
                        ("SELECT * FROM Degree WHERE LEVEL = 'GRAD' OR LEVEL = 'PHD' ");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>Degree Id</th>
                        <th>Name</th>
                        <th>Department</th>
                        <th>Level</th>
                        <td>Type</td>
                        <td>Total Units Required</td>
                        <td>Average Grade Required<br>(empty if no min avg grade)</td>
                        <td>Concentration Required?</td>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="graddegree.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="DEGREEID" size="10"></th>
                            <th><input value="" name="NAME" size="10"></th>
                            <th><input value="" name="DEPARTMENT" size="50"></th>
                            <th><select name="LEVEL">
                                <option value="GRAD">Graduate</option>
                              </select></th> 
                            <th><select name="TYPE">
                                <option value="MS">MS</option>     <!-- all grad students are MS for simplicity for now-->
                                <option value="MS">MA</option>
                                <option value="MS">MBA</option>
                                <option value="PHD">PhD</option>
                              </select></th>  
                            <th><input value="" name="TOTALUNITS" size="5"></th>
                            <th><input value="" name="AVGGRADEREQ" size="5"></th> 
                            <th><input type="radio" name="CONCENTRATION" value="TRUE" checked>Yes<br>
                                <input type="radio" name="CONCENTRATION" value="FALSE" checked>No<br>
                            </th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="graddegree.jsp" method="get">
                            <input type="hidden" value="update" name="action">
                            <td>
                                <input value="<%= rs.getString("DEGREEID") %>" 
                                    name="DEGREEID" size="10">
                            </td>
                            <td>
                                <input value="<%= rs.getString("NAME") %>" 
                                    name="NAME" size="10">
                            </td>
                            <td>
                                <input value="<%= rs.getString("DEPARTMENT") %>" 
                                    name="DEPARTMENT" size="20">
                            </td>
                            <td>
                                <input value="<%= rs.getString("LEVEL") %>"
                                    name="LEVEL" size="15">
                            </td>
                            <td>
                                <input value="<%= rs.getString("TYPE") %>"
                                    name="TYPE" size="25">
                            </td>
                            <td>
                                <input value="<%= rs.getInt("TOTALUNITS") %>"
                                    name="TOTALUNITS" size="5">
                            </td>
                            <td>
                                <input value="<%= rs.getString("AVGGRADEREQ") %>"
                                    name="AVGGRADEREQ" size="5">
                            </td>
                            <td>
                                <input value="<%= rs.getString("CONCENTRATION") %>"
                                    name="CONCENTRATION" size="5">
                            </td>
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="graddegree.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getString("DEGREEID") %>" name="DEGREEID">
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
