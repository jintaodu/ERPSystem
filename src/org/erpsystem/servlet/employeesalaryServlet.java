package org.erpsystem.servlet;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.erpsystem.dao.Dao;

import com.alibaba.fastjson.JSONObject;
import com.mysql.jdbc.Connection;

/**
 * Servlet implementation class employeesalaryServlet
 */
@WebServlet(description = "员工发放工资", urlPatterns = { "/hr/employeesalaryServlet" })
public class employeesalaryServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public employeesalaryServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html");
		response.setCharacterEncoding("utf-8");
		
		String employeename = request.getParameter("employeename");
		String salaryamount = request.getParameter("salaryamount");
		String idno         = request.getParameter("employeeidno").replace(";", "");
		
		System.out.println("员工薪资发放"+employeename+" "+salaryamount);
		
		Connection connection = Dao.connect();
		Statement statement = null;
		Date now = new Date(); 
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//可以方便地修改日期格式
		String nowdate = dateFormat.format(now);
		try{
			
			connection.setAutoCommit(true);//保证从链接池中取到的connection是自动提交事务
			statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);

			String sql = "insert into employee_transaction (idno,employeename,op,date,transaction) values ('"+idno+"','"+employeename+"','salary','"+nowdate+"','"+salaryamount+"')";
			System.out.println(sql);
			statement.executeUpdate(sql);
			sql = "update employee_info set salarylastdate='"+nowdate+"' where idno='"+idno+"';";
			statement.executeUpdate(sql);
			
			JSONObject json = new JSONObject();
			json.put("title", "发工资成功！");
			json.put("result", "姓名："+employeename+"\n身份证号："+idno+"\n发工资成功!\n工资总额："+salaryamount);
			
			System.out.println( json.toJSONString() );
			response.getWriter().write( json.toJSONString() );
			}catch(SQLException e){
				e.printStackTrace();
			}
			finally{
				try {
					if( null != statement )
						statement.close();
					if( null != connection)
						connection.close();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}//end finally
	}

}
