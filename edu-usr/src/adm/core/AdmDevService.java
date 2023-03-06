package adm.core;

import java.sql.Connection;
import java.util.List;

import adm.util.AdmDevUtil;

/**
 * 관리자 개발 service 클래스(업무 처리)
 */
public class AdmDevService {

	private AdmDevDao admDevDao = new AdmDevDao();

	/**
	 * 개발 목록 가져오기
	 * @param 	admDevVo
	 * @return	List<AdmDevVo>
	 */
	public List<AdmDevVo> getDevList(AdmDevVo admDevVo){
		return admDevDao.selectDevList(admDevVo);
	}

	/**
	 * 개발 상세 가져오기
	 * @param 	admDevVo
	 * @return	AdmDevVo
	 */
	public AdmDevVo getDev(AdmDevVo admDevVo){
		return admDevDao.selectDev(admDevVo);
	}

	/**
	 * 개발 삭제(멀티)
	 * @param 	data
	 * @return	int
	 */
	public int remove(List<AdmDevVo> dataList) {
		int result = 0;

		Connection con = null;

		try{
			con = AdmDevUtil.getConnection();
			con.setAutoCommit(false);

			for(AdmDevVo data : dataList) {
				result += admDevDao.delete(con, data);
			}

			con.commit();
			con.setAutoCommit(true);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			AdmDevUtil.closeConnection(con);
		}

		return result;
	}

	/**
	 * 개발 삭제
	 * @param 	data
	 * @return	int
	 */
	public int remove(AdmDevVo data) {
		return admDevDao.delete(data);
	}

	/**
	 * 개발 등록
	 * @param 	data
	 * @return	int
	 */
	public int create(AdmDevVo data) {
		return admDevDao.insert(data);
	}

	/**
	 * 개발 수정
	 * @param 	data
	 * @return	int
	 */
	public int modify(AdmDevVo data) {
		return admDevDao.update(data);
	}
}
