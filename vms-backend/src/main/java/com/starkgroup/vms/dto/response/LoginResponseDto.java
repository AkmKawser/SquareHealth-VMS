package com.starkgroup.vms.dto.response;

public class LoginResponseDto {

    private String token;
    private String tokenType = "Bearer";
    private String username;
    private String role;
    private Long companyId;

    public LoginResponseDto() {
    }

    public LoginResponseDto(String token, String username, String role, Long companyId) {
        this.token = token;
        this.username = username;
        this.role = role;
        this.companyId = companyId;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getTokenType() {
        return tokenType;
    }

    public void setTokenType(String tokenType) {
        this.tokenType = tokenType;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Long getCompanyId() {
        return companyId;
    }

    public void setCompanyId(Long companyId) {
        this.companyId = companyId;
    }
}

