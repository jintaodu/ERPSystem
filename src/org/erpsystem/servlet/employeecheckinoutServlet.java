package org.erpsystem.servlet;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
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
 * Servlet implementation class checkinout
 */
@WebServlet(description = "员工入职离职", urlPatterns = { "/hr/employeecheckinoutServlet" })
public class employeecheckinoutServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public employeecheckinoutServlet() {
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
	private String parameterTranscoding(String parameter){
		try {
			return new String(parameter.getBytes("iso-8859-1"),"UTF-8");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("utf-8");
		response.setContentType("application/json");
		
		String employeename = request.getParameter("employeeName");
		String salary = request.getParameter("salary");
		String checktype = request.getParameter("checktype");
		String idno = request.getParameter("employeeidno").replace(";", "");
		
		System.out.println("check in out "+employeename+" "+salary+" "+checktype+" "+idno);
		
		Connection connection = Dao.connect();
		Statement statement=null;
		
		Date now = new Date();
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//可以方便地修改日期格式
		String nowdate = dateFormat.format(now);
		JSONObject json = new JSONObject();
		
		try{
			
			connection.setAutoCommit(true);//保证从链接池中取到的connection是自动提交事务
			statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
			
			String sql = "";
			if(checktype.equals("checkin")){
				System.out.println("checkin");
				sql = "select checkindate from employee_info where idno='"+idno+"' and onsite='1';";
				System.out.println("查重语句="+sql);
				ResultSet resultSet =  statement.executeQuery(sql);
				int rowCount = 0;
				if(resultSet.next()){
					rowCount++;
				}
				if( rowCount > 0 ) {
					String checkindate = resultSet.getString(1);
					json.put("title", "身份证号已经存在！");
					json.put("result", "入职日期为："+checkindate+"\n请确认身份证号输入正确！或者该员工上次未进行离职登记！");
					
					System.out.println(json.toString());
					response.getWriter().write( json.toJSONString() );
					return;
				}
				resultSet.close();

				sql = "insert into employee_info (idno,employeename,onsite,salary,checkindate,salarylastdate) values ('"+idno+"','"
					  +employeename+"','1','"+salary+"','"+nowdate+"','"+nowdate+"')" + " ON DUPLICATE KEY UPDATE onsite='1', checkindate='"
					  +nowdate+"',salary='"+salary+"',salarylastdate='"+nowdate+"';";
				
				System.out.println("更新员工信息表employee_info："+sql);
				statement.executeUpdate(sql);
				
				sql = "insert into employee_transaction(idno,employeename,op,date,transaction) values ('"+idno+"','"+employeename+"','checkin','"+nowdate+"','checkin')";
				System.out.println("更新员工事务表employee_transaction："+sql);
				statement.executeUpdate(sql);
				json.put("title", "新员工添加成功！");
				json.put("result", "员工姓名："+employeename+"   员工身份证号："+idno);
				
				System.out.println(json.toJSONString() );
				response.getWriter().write( json.toJSONString() );
			
				
			}else if(checktype.equals("checkout")){
				System.out.println("checkout");
				sql = "select count(*) as rowCount from employee_info where employeename='"+employeename+"' and idno='"+idno+"';";
				ResultSet resultSet = statement.executeQuery(sql);
				int rowCount = 0;
				if(resultSet.next()){
					rowCount = resultSet.getInt("rowCount");
				}
				resultSet.close();
				if(0 == rowCount){
					json.put("title", "身份证号与姓名不匹配！");
					json.put("result", "请重新输入！");
					System.out.println(json.toString());
					response.getWriter().write( json.toJSONString() );
					return;
				}
				
				sql="update employee_info set onsite='0', checkoutdate='"+nowdate+"' where idno='"+idno+"';";
				System.out.println(sql);
				statement.executeUpdate(sql);
				
				sql = "insert into employee_transaction(idno,employeename,op,date,transaction) values ('"+idno+"','"+employeename+"','checkout','"+nowdate+"','checkout')";
				System.out.println("更新员工事务表："+sql);
				statement.executeUpdate(sql);
				
				json.put("title", "员工离职成功！");
				json.put("result", "员工姓名："+employeename+"\n员工身份证号："+idno);
				
				System.out.println(json.toJSONString() );
				response.getWriter().write( json.toJSONString() );
				
			}
	
		}catch (SQLException e) {
			// TODO Auto-generated catch block
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
