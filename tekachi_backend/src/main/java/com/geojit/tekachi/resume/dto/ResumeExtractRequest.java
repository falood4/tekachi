package com.geojit.tekachi.resume.dto;

import org.springframework.web.multipart.MultipartFile;

public class ResumeExtractRequest {

    private MultipartFile file;

    public MultipartFile getFile() {
        return file;
    }

    public void setFile(MultipartFile file) {
        this.file = file;
    }
}
