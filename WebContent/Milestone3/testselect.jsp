<html>
<body>
    <table border="1">
        <tr>
            <td valign="top">
            <%-- -------- Include menu HTML code -------- --%>
            <jsp:include page="RequestForms.html" />
        </td>
        <td>
            <%-- Import the java.sql package --%>
            <%@ page import="java.sql.*"%>
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

            <%
                int currentyear = 2016;
                String currentquarter = "WINTER";
                String action = request.getParameter("action");
                // Check if an insertion is requested
                if (action != null && action.equals("submit")) {

                    ResultSet resset1 = null;
                    Statement stmt = null;

                    String[] parts = request.getParameter("SSNSID").split(",");
                    String SSN = parts[0]; // 004
                    String SID = parts[1]; 
                    // Begin transaction
                    conn.setAutoCommit(false);

                    %>

                    <table border="1">
                    <tr>
                        <td>
                            <%=SSN%>
                        </td>
                        <td>
                            <%=SID%>
                        </td>
                    </tr>
                    </table>
                    <%
                }
            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                // Create the statement
                Statement statement = conn.createStatement();
                ResultSet resset = null;

                 // Select all undergraduate students to populate our dropdown menu
                PreparedStatement ps = conn.prepareStatement("select s.SSN, s.STUDENTID, s.FIRSTNAME, s.MIDDLENAME, s.LASTNAME " +
                                                "from Student s, Undergrad u "+
                                                "where s.STUDENTID = u.STUDENTID AND EXISTS (select * from Enrolled e where s.STUDENTID = e.STUDENTID AND e.QUARTER = ? AND e.YEAR = ?)");
                ps.setString(1, currentquarter);
                ps.setInt(2, currentyear);

                resset = ps.executeQuery();

            %>
            <hr>
            <!-- Student Insertion Form -->
    <form action="testselect.jsp" method="POST">
        
        <div>
            Select Student:
            <select name="SSNSID">
                <%
                    while(resset.next()){
                        %>
                        <option value='<%=resset.getInt("SSN")%>,<%=resset.getString("STUDENTID")%>'>
                            <%=resset.getInt("SSN")%>, <%=resset.getString("STUDENTID")%>, <%=resset.getString("FIRSTNAME")%> <%=resset.getString("LASTNAME")%>
                        </option>
                        <%
                    }
                %>
            </select>
        </div>
            <br />
        </div>
        <p>
        
        <button type="submit" name="action" value="submit">Submit</button>
        
    </form>
            

            <%-- -------- Close Connection Code -------- --%>
            <%
                // Close the ResultSet
                    resset.close();
    
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
        </td>
    </tr>
</table>
</body>

</html>

  

