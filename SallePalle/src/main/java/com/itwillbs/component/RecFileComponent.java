package com.itwillbs.component;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

@Component
public class RecFileComponent {

	// 업로드 저장 경로
	private final String recSaveDirectory = "/usr/local/tomcat/upload/recfile";
	
	public RecFileComponent() {
		File dir = new File(recSaveDirectory);
		if(!dir.exists()) {
			dir.mkdirs(); // 폴더 없으면 생성
		}
	}
	
	// 단일 파일 업로드(썸네일)
	public String thumbUpload(MultipartFile file) {
		if(file == null || file.isEmpty()) {
			return null;
		}
		
		String originalName = file.getOriginalFilename();
		String extName = originalName.substring(originalName.lastIndexOf("."));
		String storedFileName = UUID.randomUUID().toString().replace("-", "") + extName;
		
		File dest = new File(recSaveDirectory, storedFileName);
		try {
			file.transferTo(dest);
			return storedFileName;
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
		
	}
	
	// 다중 파일 업로드(자료 파일)
	public List<String> attachUpload(List<MultipartFile> files) {
		List<String> storedNames = new ArrayList<>();
		if(files == null || files.isEmpty()) {
			return storedNames;
		}
		
		for(MultipartFile f : files) {
			if(!f.isEmpty()) {
				String stored = thumbUpload(f);
				if(stored != null) {
					storedNames.add(stored);
				}
			}
		}
		return storedNames;
	}
	
	// 파일 삭제 메서드
	public boolean recDeleteFile(String storedFileName) {
		File f = new File(recSaveDirectory, storedFileName);
		if (f.exists()) {
            return f.delete();
        }
        return false;
	}
}
