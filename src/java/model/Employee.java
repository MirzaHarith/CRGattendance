package model;

public class Employee {
    private String employeeID;
    private String employeeName;
    private String employeePassword;
    private String employeePosition;
    private byte[] employeeImage;
    private int employeePhoneNum;
    private String employeeBankAccount;
    private int employeeAccountNum;
    private String employeeGender;
    private int leaveBalance;
    private int payRate;

    // Getters and Setters
    public String getEmployeeID() {
        return employeeID;
    }

    public void setEmployeeID(String employeeID) {
        this.employeeID = employeeID;
    }

    public String getEmployeeName() {
        return employeeName;
    }

    public void setEmployeeName(String employeeName) {
        this.employeeName = employeeName;
    }

    public String getEmployeePassword() {
        return employeePassword;
    }

    public void setEmployeePassword(String employeePassword) {
        this.employeePassword = employeePassword;
    }

    public String getEmployeePosition() {
        return employeePosition;
    }

    public void setEmployeePosition(String employeePosition) {
        this.employeePosition = employeePosition;
    }

    public byte[] getEmployeeImage() {
        return employeeImage;
    }

    public void setEmployeeImage(byte[] employeeImage) {
        this.employeeImage = employeeImage;
    }

    public int getEmployeePhoneNum() {
        return employeePhoneNum;
    }

    public void setEmployeePhoneNum(int employeePhoneNum) {
        this.employeePhoneNum = employeePhoneNum;
    }

    public String getEmployeeBankAccount() {
        return employeeBankAccount;
    }

    public void setEmployeeBankAccount(String employeeBankAccount) {
        this.employeeBankAccount = employeeBankAccount;
    }

    public int getEmployeeAccountNum() {
        return employeeAccountNum;
    }

    public void setEmployeeAccountNum(int employeeAccountNum) {
        this.employeeAccountNum = employeeAccountNum;
    }

    public String getEmployeeGender() {
        return employeeGender;
    }

    public void setEmployeeGender(String employeeGender) {
        this.employeeGender = employeeGender;
    }

    public int getLeaveBalance() {
        return leaveBalance;
    }

    public void setLeaveBalance(int leaveBalance) {
        this.leaveBalance = leaveBalance;
    }
    
    public int getPayRate() {
        return payRate;
    }

    public void setPayRate(int payRate) {
        this.payRate = payRate;
    }
}
