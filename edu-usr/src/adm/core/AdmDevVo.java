package adm.core;

import java.util.Date;

/**
 * 관리자 개발 vo 클래스(데이터 모델)
 */
public class AdmDevVo {

	private Integer num = null;		// 순번
	private String title = null;	// 제목
	private String cont = null;		// 내용
	private String cateCd = null;	// 카테고리 코드
	private String noteYn = null;	// 공지여부
	private Date regDt = null;		// 등록일
	private Date modDt = null;		// 수정일

	/**
	 * 생성자
	 */
	public AdmDevVo() {}

	/**
	 * 생성자
	 * @param 	num
	 * @param 	title
	 * @param 	cont
	 * @param 	cateCd
	 * @param 	noteYn
	 * @param 	regDt
	 * @param 	modDt
	 */
	public AdmDevVo(Integer num, String title, String cont, String cateCd, String noteYn, Date regDt, Date modDt) {
		super();
		this.num = num;
		this.title = title;
		this.cont = cont;
		this.cateCd = cateCd;
		this.noteYn = noteYn;
		this.regDt = regDt;
		this.modDt = modDt;
	}

	public Integer getNum() {
		return num;
	}
	public void setNum(Integer num) {
		this.num = num;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getCont() {
		return cont;
	}
	public void setCont(String cont) {
		this.cont = cont;
	}
	public String getCateCd() {
		return cateCd;
	}
	public void setCateCd(String cateCd) {
		this.cateCd = cateCd;
	}
	public String getNoteYn() {
		return noteYn;
	}
	public void setNoteYn(String noteYn) {
		this.noteYn = noteYn;
	}
	public Date getRegDt() {
		return regDt;
	}
	public void setRegDt(Date regDt) {
		this.regDt = regDt;
	}
	public Date getModDt() {
		return modDt;
	}
	public void setModDt(Date modDt) {
		this.modDt = modDt;
	}
}
