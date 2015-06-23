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
 * Servlet implementation class productcheckinoutServlet
 */
@WebServlet(description = "货物进仓出仓", urlPatterns = { "/warehouse/productcheckinoutServlet" })
public class productcheckinoutServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public productcheckinoutServlet() {
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
		
		String productname    = request.getParameter("productname");
		String producttype    = request.getParameter("producttype");
		String checkinamount  = request.getParameter("checkinamount");
		String checkoutamount = request.getParameter("checkoutamount");
		String checktype      = request.getParameter("checktype");
		String productlocation= request.getParameter("productlocation");
		
		System.out.println("check in out"+productname+" "+producttype+" "+checkinamount);
		
		Connection connection = Dao.connect();
		Statement statement = null;
		
		Date now = new Date(); 
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//可以方便地修改日期格式
		String nowdate = dateFormat.format(now);
		String sql = "";
		JSONObject json = new JSONObject();
		
		try{
			
			connection.setAutoCommit(true);//保证从链接池中取到的connection是自动提交事务
			statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
			
			if(checktype.equals("checkin")){
				System.out.println("checkin");

				sql = "insert into product_transaction (productname,producttype,productlocation,date,event) values ('"
						+productname+"','"+producttype+"','"+productlocation+"','"+nowdate+"','+"+checkinamount+"')";
				System.out.println("插入货物事务表product_transaction:"+sql);
				statement.executeUpdate(sql);
				
				sql = "insert into product_info (productname,producttype,productlocation,productamount) values ('"
						+productname+"','"+producttype + "','" + productlocation + "','" + checkinamount+"') "+
						"ON DUPLICATE KEY UPDATE productamount = productamount + '"+checkinamount+"';";
				
				System.out.println("更新product_info表:"+sql);
				statement.executeUpdate(sql);
				
				json.put("title", "入仓成功！");
				json.put("result", "货物："+productname+"\n,型号："+producttype+"\n入仓成功！");
				System.out.println( json.toJSONString() );
				
				response.getWriter().write(json.toJSONString());
				
				
			}else if(checktype.equals("checkout")){
				System.out.println("checkout");
				sql = "insert into product_transaction (productname,producttype,productlocation,date,event) values ('"+productname+"','"
						+producttype+"','"+productlocation+"','"+nowdate+"','-"+checkoutamount+"')";
				System.out.println("签出货物product transaction更新sql="+sql);	
				statement.executeUpdate(sql);
				sql = "update product_info set productamount = productamount - '"+checkoutamount+"' where productname='"+productname
						+"' and producttype='"+producttype+"' and productlocation='"+productlocation+"'";
				statement.execute(sql);
				System.out.println("签出货物product info更新sql="+sql);
				
				json.put("title", "出仓成功！");
				json.put("result", "货物："+productname+"\n,型号："+producttype+"\n出仓成功！");
				System.out.println( json.toJSONString() );
				response.getWriter().write(json.toJSONString());
				
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
