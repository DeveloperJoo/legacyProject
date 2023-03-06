package adm.core;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import adm.util.AdmDevUtil;

/**
 * 관리자 개발 dao 클래스(DB 처리)
 */
public class AdmDevDao {

	/**
	 * 개발 목록 가져오기
	 * @param 	admDevVo
	 * @return	List<AdmDevVo>
	 */
	public List<AdmDevVo> selectDevList(AdmDevVo admDevVo){
		List<AdmDevVo> dataList = null;

		Connection con = null;
		PreparedStatement pst = null;
		ResultSet rs = null;

		try{
			// 쿼리 만들기
			StringBuffer sb = new StringBuffer();
			sb.append("SELECT NUM,TITLE,CATE_CD,NOTE_YN,REG_DT,MOD_DT FROM ZTB_EDU_BOARD WHERE 1=1");

			if(admDevVo.getTitle() != null && !admDevVo.getTitle().equals("")){
				sb.append(" AND (TITLE LIKE '%' || ? || '%' OR CONT LIKE '%' || ? || '%')");
			}

			if(admDevVo.getCateCd() != null && !admDevVo.getCateCd().equals("")){
				sb.append(" AND CATE_CD = ?");
			}

			if(admDevVo.getNoteYn() != null && admDevVo.getNoteYn().equals("Y")){
				sb.append(" AND NOTE_YN = 'Y'");
			}

			sb.append(" ORDER BY NUM DESC");

			// db 데이터 가져오기
			con = AdmDevUtil.getConnection();
			pst = con.prepareStatement(sb.toString());
			int paramIdx = 1;

			if(admDevVo.getTitle() != null && !admDevVo.getTitle().equals("")){
				pst.setString(paramIdx++, admDevVo.getTitle());
				pst.setString(paramIdx++, admDevVo.getTitle());
			}

			if(admDevVo.getCateCd() != null && !admDevVo.getCateCd().equals("")){
				pst.setString(paramIdx++, admDevVo.getCateCd());
			}

			AdmDevUtil.sysLog("# 실행쿼리 : " + sb.toString());

			rs = pst.executeQuery();

			while(rs.next()){
				if(dataList == null) {
					dataList = new ArrayList<AdmDevVo>();
				}

				AdmDevVo data = new AdmDevVo(rs.getInt("NUM"), rs.getString("TITLE"), null, rs.getString("CATE_CD"), rs.getString("NOTE_YN"), rs.getDate("REG_DT"), rs.getDate("MOD_DT"));
				dataList.add(data);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			AdmDevUtil.closeConnection(con, pst, rs);
		}

		return dataList;
	}

	/**
	 * 개발 상세 가져오기
	 * @param 	admDevVo
	 * @return	AdmDevVo
	 */
	public AdmDevVo selectDev(AdmDevVo admDevVo){
		AdmDevVo data = null;

		Connection con = null;
		PreparedStatement pst = null;
		ResultSet rs = null;

		try{
			// 쿼리 만들기
			StringBuffer sb = new StringBuffer();
			sb.append("SELECT NUM,TITLE,CONT,CATE_CD,NOTE_YN,REG_DT,MOD_DT FROM ZTB_EDU_BOARD WHERE NUM=?");

			// db 데이터 가져오기
			con = AdmDevUtil.getConnection();
			pst = con.prepareStatement(sb.toString());
			pst.setInt(1, admDevVo.getNum());
		
			AdmDevUtil.sysLog("# 실행쿼리 : " + sb.toString());
		
			rs = pst.executeQuery();
		
			while(rs.next()){
				data = new AdmDevVo(rs.getInt("NUM"), rs.getString("TITLE"), rs.getString("CONT"), rs.getString("CATE_CD"), rs.getString("NOTE_YN"), rs.getDate("REG_DT"), rs.getDate("MOD_DT"));
				break;
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			AdmDevUtil.closeConnection(con, pst, rs);
		}

		return data;
	}

	public int delete(AdmDevVo data) {
		int result = 0;

		Connection con = null;

		try{
			con = AdmDevUtil.getConnection();

			result = delete(con, data);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			AdmDevUtil.closeConnection(con);
		}

		return result;
	}

	/**
	 * 개발 삭제
	 * @param 	con
	 * @param 	data
	 * @return	int
	 */
	public int delete(Connection con, AdmDevVo data) {
		int result = 0;

		PreparedStatement pst = null;

		try{
			// 쿼리 만들기
			StringBuffer sb = new StringBuffer();
			sb.append("DELETE FROM ZTB_EDU_BOARD WHERE NUM=?");

			pst = con.prepareStatement(sb.toString());
			pst.setInt(1, data.getNum());

			AdmDevUtil.sysLog("# 실행쿼리 : " + sb.toString());

			result = pst.executeUpdate();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			AdmDevUtil.closeConnection(pst);
		}

		return result;
	}

	/**
	 * 개발 등록
	 * @param 	data
	 * @return	int
	 */
	public int insert(AdmDevVo data) {
		int result = 0;

		Connection con = null;
		PreparedStatement pst = null;
		ResultSet rs = null;

		try{
			// 쿼리 만들기
			StringBuffer sb = new StringBuffer();
			sb.append("SELECT NVL(MAX(NUM), 0) + 1 AS NEXT_NUM FROM ZTB_EDU_BOARD");

			// db 데이터 가져오기
			con = AdmDevUtil.getConnection();
			pst = con.prepareStatement(sb.toString());
			rs = pst.executeQuery();

			AdmDevUtil.sysLog("# 실행쿼리 : " + sb.toString());

			while(rs.next()){
				data.setNum(rs.getInt("NEXT_NUM"));
				break;
			}

			rs.close();
			pst.close();

			// 쿼리문 초기화
			sb.setLength(0);

			sb.append("INSERT INTO ZTB_EDU_BOARD(NUM,TITLE,CONT,CATE_CD,NOTE_YN,REG_DT,MOD_DT) VALUES(?,?,?,?,?,SYSDATE,SYSDATE)");

			pst = con.prepareStatement(sb.toString());
			int paramIdx = 1;
			pst.setInt(paramIdx++, data.getNum());
			pst.setString(paramIdx++, data.getTitle());
			pst.setString(paramIdx++, data.getCont());
			pst.setString(paramIdx++, data.getCateCd());
			pst.setString(paramIdx++, data.getNoteYn());

			AdmDevUtil.sysLog("# 실행쿼리 : " + sb.toString());
		
			result = pst.executeUpdate();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			AdmDevUtil.closeConnection(con, pst);
		}

		return result;
	}

	/**
	 * 개발 수정
	 * @param 	data
	 * @return	int
	 */
	public int update(AdmDevVo data) {
		int result = 0;

		Connection con = null;
		PreparedStatement pst = null;

		try{
			// 쿼리 만들기
			StringBuffer sb = new StringBuffer();
			sb.append("UPDATE ZTB_EDU_BOARD SET TITLE=?,CONT=?,CATE_CD=?,NOTE_YN=?,MOD_DT=SYSDATE WHERE NUM=?");

			// db 데이터 가져오기
			con = AdmDevUtil.getConnection();
			pst = con.prepareStatement(sb.toString());
			int paramIdx = 1;
			pst.setString(paramIdx++, data.getTitle());
			pst.setString(paramIdx++, data.getCont());
			pst.setString(paramIdx++, data.getCateCd());
			pst.setString(paramIdx++, data.getNoteYn());
			pst.setInt(paramIdx++, data.getNum());

			AdmDevUtil.sysLog("# 실행쿼리 : " + sb.toString());

			result = pst.executeUpdate();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			AdmDevUtil.closeConnection(con, pst);
		}

		return result;
	}
}
