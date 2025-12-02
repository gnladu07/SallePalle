package com.itwillbs.component;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

@Component
public class FileComponent {

	private static final Logger logger = LoggerFactory.getLogger(FileComponent.class);
	
	private String saveDirectory = "/usr/local/tomcat/upload/";
	
	public FileComponent() {
		File dir = new File(saveDirectory);
		if(dir.exists() == false) {
			dir.mkdirs();
		}
	}
	
	// 파일 업로드 메소드
	public List<String> uploadFiles(MultipartFile[] files) {
        List<String> storedFileNames = new ArrayList<>();

        if (files == null || files.length == 0) {
            return storedFileNames;
        }

        for (MultipartFile file : files) {
            if (file.isEmpty()) continue;

            String extName = file.getOriginalFilename()
                    .substring(file.getOriginalFilename().lastIndexOf("."));
            String storedFileName = UUID.randomUUID().toString().replace("-", "") + extName;
            File dest = new File(saveDirectory, storedFileName);

            try {
                file.transferTo(dest);
                storedFileNames.add(storedFileName);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        return storedFileNames;
    }

    // 단일 파일 삭제
    public void delete(String storedFileName) {
        File file = new File(saveDirectory, storedFileName);
        if (file.exists()) {
            file.delete();
            System.out.println("삭제 완료: " + storedFileName);
        }
    }
    
    /////////////////////////////////////////
    // 단일 파일 업로드
    public String upload(MultipartFile f) {
    	String extName = f.getOriginalFilename().substring(f.getOriginalFilename().lastIndexOf("."));
    	String storedFileName = UUID.randomUUID().toString().replace("-", "");
    	storedFileName += extName;
    	File dest = new File(saveDirectory, storedFileName);
    	try {
    		f.transferTo(dest);
    		return storedFileName;
    	}catch(Exception e){
    		e.printStackTrace();
    	}
    	
    	return null;
    }
    
    
    // === 사업자등록증 PDF 전용 업로드 ===
    public String[] uploadBusinessLicense(MultipartFile file) throws IOException{
    	if(file == null || file.isEmpty()) {
    		throw new IOException("파일이 비어있습니다.");
    	}
    	
    	String originalName = file.getOriginalFilename();
    	
    	// 확장자 검사
    	if(!originalName.endsWith(".pdf")) {
    		throw new IOException("사업자 등록증은 PDF 파일만 업로드 가능합니다.");
    	}
    	
    	// 파일명 생성
    	String extName = originalName.substring(originalName.lastIndexOf("."));
    	String storedFileName = UUID.randomUUID().toString().replace("-", "") + extName;
    	
    	// 저장 경로
    	File saveDir = new File(saveDirectory, "business_license");
    	if(!saveDir.exists()) {
    		saveDir.mkdirs();
    	}
    	
    	// 실제 파일 저장
    	File dest = new File(saveDir, storedFileName);
    	file.transferTo(dest);
    	
    	logger.debug("사업자등록증 저장 완료 : " +dest.getAbsolutePath());
    	
    	return new String[] {storedFileName, originalName};
    }
    
    public boolean businessLicenseExists(String storedFileName) {
        File file = new File(saveDirectory + "business_license", storedFileName);
        return file.exists();
    }
}
