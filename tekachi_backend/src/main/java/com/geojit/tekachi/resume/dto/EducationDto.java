package com.geojit.tekachi.resume.dto;

public class EducationDto {

    private SchoolRecordDto class10;
    private SchoolRecordDto class12;
    private UgRecordDto ugCgpa;

    public SchoolRecordDto getClass10() {
        return class10;
    }

    public void setClass10(SchoolRecordDto class10) {
        this.class10 = class10;
    }

    public SchoolRecordDto getClass12() {
        return class12;
    }

    public void setClass12(SchoolRecordDto class12) {
        this.class12 = class12;
    }

    public UgRecordDto getUgCgpa() {
        return ugCgpa;
    }

    public void setUgCgpa(UgRecordDto ugCgpa) {
        this.ugCgpa = ugCgpa;
    }
}
