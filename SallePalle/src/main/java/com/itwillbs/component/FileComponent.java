package com.itwillbs.component;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

@Component
public class FileComponent {
	
	private String saveDirectory = "C:\\upload\\";
	
	public FileComponent() {
		File dir = new File(saveDirectory);
		if(dir.exists() == false) {
			dir.mkdirs();
		}
	}
	
	public String upload(MultipartFile f) {
		String extName = f.getOriginalFilename().substring(f.getOriginalFilename().lastIndexOf("."));
		String storedFileName = UUID.randomUUID().toString().replace("-", "") ;
		storedFileName += extName;
		File dest = new File(saveDirectory, storedFileName);
		try {
			f.transferTo(dest);
			return storedFileName;
		} catch (IllegalStateException | IOException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public boolean deleteFile(String storedFileName) {
		File f = new File(saveDirectory ,storedFileName);
		
		System.out.println("썸네일 삭제 시도 경로: " + f.getAbsolutePath());
	    System.out.println("파일 존재 여부: " + f.exists());
		
		if(f.exists()) {
			return f.delete();
		}
		return false;
	}

}
