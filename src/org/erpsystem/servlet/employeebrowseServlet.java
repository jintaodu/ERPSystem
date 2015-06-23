package org.erpsystem.servlet;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.erpsystem.dao.Dao;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.mysql.jdbc.Connection;

/**
 * Servlet implementation class employeebrowseServlet
 */
@WebServlet(description = "获取员工基本信息", urlPatterns = { "/hr/employeebrowseServlet" })
public class employeebrowseServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public employeebrowseServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 * 获得员工的基本信息，包括：身份证号，姓名，入职日期
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("utf-8");
		response.setContentType("application/json");
		
		String browsetype = request.getParameter("browsetype");
		String idno       = request.getParameter("idno");
		
		Connection connection = Dao.connect();
		Statement statement = null;
		
		try{
			
			connection.setAutoCommit(true);//保证从链接池中取到的connection是自动提交事务
			statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
			String sql = "desc employee_info;";
			ResultSet resultSet = statement.executeQuery(sql);
			ArrayList<String> employee_info_cols = new ArrayList<String>();
			while(resultSet.next()){
				employee_info_cols.add(resultSet.getString(1));
			}
			resultSet.close();
			
			JSONObject json = new JSONObject();
			//根据请求的不同类型返回不同的json
			if(browsetype.equals("all")){
				
				sql = "select * from employee_info;";
				System.out.println(sql);
				resultSet = statement.executeQuery(sql);
				
			}else if(browsetype.equals("onlyonsite")){
				
				sql = "select * from employee_info where onsite='1';";
				System.out.println(sql);
				resultSet = statement.executeQuery(sql);
				
			}else if(browsetype.equals("history")){
				
				sql = "desc employee_transaction;";
				resultSet = statement.executeQuery(sql);
				ArrayList<String> employee_transaction_cols = new ArrayList<String>();
				while(resultSet.next()){
					System.out.println(resultSet.getString(1));
					employee_transaction_cols.add(resultSet.getString(1));
				}
				
				sql = "select * from employee_transaction where idno='"+idno+"';";
				System.out.println("获取历史信息sql："+sql);
				resultSet = statement.executeQuery(sql);
				JSONArray jsonarray = new JSONArray();
				while(resultSet.next()){
					JSONArray arr = new JSONArray();
					for(int i=0; i < employee_transaction_cols.size(); ++i){
						//System.out.println(resultSet.getString(i + 1));
						arr.add(resultSet.getString(i + 1));
					}
					jsonarray.add(arr);
				}
				resultSet.close();
				
				System.out.println("历史信息"+jsonarray.toJSONString() );
				response.getWriter().write( jsonarray.toJSONString() );
				return;
			}
			
			
			
			while(resultSet.next()){
				JSONObject arr = new JSONObject();
				for(int i = 0; i < employee_info_cols.size(); ++i){//value为null的项不会被加入进来
					arr.put(employee_info_cols.get(i), resultSet.getString( i + 1));
				}
				json.put( resultSet.getString(1) , arr);
			}
			
			resultSet.close();
			
			System.out.println(json.toJSONString() );
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

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}
