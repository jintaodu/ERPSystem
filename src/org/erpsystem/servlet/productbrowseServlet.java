package org.erpsystem.servlet;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

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
 * Servlet implementation class productbrowseServlet
 */
@WebServlet(description = "获取货物基本信息", urlPatterns = { "/warehouse/productbrowseServlet" })
public class productbrowseServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public productbrowseServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		request.setCharacterEncoding("UTF-8");
		response.setContentType("application/json");
		response.setCharacterEncoding("utf-8");
		
		String browsetype = request.getParameter("browsetype");
		
		Connection connection = Dao.connect();
		Statement statement = null;
		
		try{
			connection.setAutoCommit(true);//保证从链接池中取到的connection是自动提交事务
			statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
			
			String sql = "desc product_info;";
			ResultSet resultSet =  statement.executeQuery(sql);
			
			ArrayList<String> product_info_cols = new ArrayList<String>();
			while(resultSet.next()){
				product_info_cols.add(resultSet.getString(1));
			}
			
			sql = "select * from product_info order by productname desc";
			System.out.println("查询仓库库存信息sql"+sql);
			resultSet =  statement.executeQuery(sql);
			
			if(browsetype.equals("table")){
				
				JSONArray jsonarray = new JSONArray();
				
				while(resultSet.next()){
					JSONArray arr = new JSONArray();
					for(int i = 0; i < product_info_cols.size(); ++i){
						arr.add(resultSet.getString(i+1));
					}
					jsonarray.add(arr);
				}
				resultSet.close();
				System.out.println("仓库库存信息"+jsonarray.toJSONString() );
				response.getWriter().write( jsonarray.toJSONString() );
				
			}else if(browsetype.equals("all")){
				JSONArray jsonarray = new JSONArray();
				
				while(resultSet.next()){
					JSONObject json = new JSONObject();
					for(int i = 0; i < product_info_cols.size(); ++i){
						json.put(product_info_cols.get(i), resultSet.getString(i+1));
					}
					jsonarray.add(json);
				}
				resultSet.close();
				System.out.println("仓库库存信息"+jsonarray.toJSONString() );
				response.getWriter().write( jsonarray.toJSONString() );
			}
			
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
