package org.erpsystem.dao;


import java.io.UnsupportedEncodingException;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.mysql.jdbc.Connection;

public class Dao {

	/**
	 * @param args
	 */
	public static Connection connect() {
		// 驱动程序名
		String driver = "com.mysql.jdbc.Driver";

		// URL指向要访问的数据库名erpdb
		String url = "jdbc:mysql://10.171.6.72:3306/erpdb";

		// MySQL配置时的用户名
		String user = "root";

		// MySQL配置时的密码
		String password = "root";
		Connection conn = null;
		try{
			Class.forName(driver);

			// 连续数据库
			conn = (Connection) DriverManager.getConnection(url, user,
					password);

			if (!conn.isClosed())
				System.out.println("Succeeded connecting to the Database!");

		}catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return conn;

	}

	public static void main(String[] args) throws UnsupportedEncodingException {
		// TODO Auto-generated method stub
			Connection connection = Dao.connect();
			//if(null == conn) System.out.println("123");
			String employeename="小红5";
			//employeename = new String(employeename.getBytes("latin1"),"latin1");
			//employeename = new String(employeename.getBytes("GBK"),"GBK");
			
			String salary="1000";
			Date now = new Date(); 
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");//可以方便地修改日期格式
			
			String sql = "insert into employee_info (employeename,available,salary,checkindate) values ('"+employeename+"','1','"+salary+"','"+dateFormat.format(now)+"')";
			System.out.println(sql);
			//PreparedStatement psmt = connection.prepareStatement(sql);
			if(null == connection) System.out.println("123654789");
			try{
				Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
				statement.executeUpdate(sql);
				
				System.out.println("12345");
				
				//connection.commit();
				statement.close();
				
			}catch(SQLException e){
				e.printStackTrace();
			}
			
	}

}

