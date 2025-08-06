<%@page import="com.entity.Appointment"%>
<%@page import="java.util.List"%>
<%@page import="com.db.DBConnect"%>
<%@page import="com.dao.AppointmentDao"%>
<%@page import="com.entity.Doctor"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CureWell | View Patients</title>
    <link rel="icon" type="image/png" href="../img/favicon.ico"/>
    <%@include file="../component/allcss.jsp"%>

    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .overlay {
            background: rgba(255, 255, 255, 0.1);
            min-height: 100vh;
            padding: 80px 0 40px 0;
        }

        .paint-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            padding: 30px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .heading {
            font-size: 28px;
            font-weight: 700;
            color: #2c3e50;
            text-align: center;
            text-transform: uppercase;
            margin-bottom: 30px;
            letter-spacing: 1px;
            position: relative;
        }

        .heading::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 3px;
            background: linear-gradient(45deg, #667eea, #764ba2);
            border-radius: 2px;
        }

        .table-container {
            overflow-x: auto;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            background: #fff;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            margin: 0;
            font-size: 14px;
            min-width: 1000px;
        }

        .table thead {
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: #fff;
        }

        .table th {
            padding: 18px 16px;
            text-align: center;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border: none;
            position: sticky;
            top: 0;
            z-index: 10;
        }

        .table td {
            padding: 16px;
            text-align: center;
            border-bottom: 1px solid #e9ecef;
            vertical-align: middle;
            transition: all 0.3s ease;
        }

        .table tbody tr {
            transition: all 0.3s ease;
        }

        .table tbody tr:nth-child(even) {
            background-color: #f8f9fa;
        }

        .table tbody tr:hover {
            background: linear-gradient(45deg, #e3f2fd, #f3e5f5);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        /* Specific column styling */
        .table th:nth-child(1), .table td:nth-child(1) {
            min-width: 180px;
            font-weight: 600;
            color: #2c3e50;
        }

        .table th:nth-child(2), .table td:nth-child(2) {
            min-width: 80px;
        }

        .table th:nth-child(3), .table td:nth-child(3) {
            min-width: 60px;
        }

        .table th:nth-child(4), .table td:nth-child(4) {
            min-width: 130px;
            color: #495057;
        }

        .table th:nth-child(5), .table td:nth-child(5) {
            min-width: 200px;
            color: #007bff;
        }

        .table th:nth-child(6), .table td:nth-child(6) {
            min-width: 120px;
        }

        .table th:nth-child(7), .table td:nth-child(7) {
            min-width: 150px;
            word-break: break-word;
            font-weight: 500;
        }

        .table th:nth-child(8), .table td:nth-child(8) {
            min-width: 120px;
        }

        .table th:nth-child(9), .table td:nth-child(9) {
            min-width: 100px;
        }

        /* Status badges */
        .status-pending {
            background: linear-gradient(45deg, #ffeaa7, #fdcb6e);
            color: #d63031;
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-completed {
            background: linear-gradient(45deg, #00b894, #00cec9);
            color: white;
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-other {
            background: linear-gradient(45deg, #a29bfe, #6c5ce7);
            color: white;
            padding: 6px 12px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* Button styling */
        .btn-comment {
            background: linear-gradient(45deg, #00b894, #00cec9);
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 25px;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0, 184, 148, 0.3);
        }

        .btn-comment:hover {
            background: linear-gradient(45deg, #00a085, #00b7b7);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 184, 148, 0.4);
            color: white;
        }

        .btn-comment.disabled {
            background: linear-gradient(45deg, #ddd, #bbb);
            color: #666;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }

        .btn-comment.disabled:hover {
            background: linear-gradient(45deg, #ddd, #bbb);
            transform: none;
            box-shadow: none;
        }

        /* Alert styling */
        .alert-custom {
            border-radius: 15px;
            padding: 15px 20px;
            margin-bottom: 25px;
            border: none;
            font-weight: 500;
        }

        .alert-success {
            background: linear-gradient(45deg, #d4edda, #c3e6cb);
            color: #155724;
        }

        .alert-danger {
            background: linear-gradient(45deg, #f8d7da, #f1aeb5);
            color: #721c24;
        }

        /* Responsive design */
        @media (max-width: 1200px) {
            .paint-card {
                margin: 0 15px;
            }
        }

        @media (max-width: 768px) {
            .overlay {
                padding: 60px 0 30px 0;
            }

            .paint-card {
                padding: 20px;
                margin: 0 10px;
                border-radius: 15px;
            }

            .heading {
                font-size: 22px;
                margin-bottom: 20px;
            }

            .table {
                font-size: 12px;
                min-width: 800px;
            }

            .table th, .table td {
                padding: 12px 8px;
            }

            .btn-comment {
                padding: 6px 12px;
                font-size: 11px;
            }
        }

        @media (max-width: 480px) {
            .heading {
                font-size: 18px;
            }

            .table {
                font-size: 11px;
            }

            .table th, .table td {
                padding: 10px 6px;
            }
        }

        /* Scrollbar styling */
        .table-container::-webkit-scrollbar {
            height: 8px;
        }

        .table-container::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 10px;
        }

        .table-container::-webkit-scrollbar-thumb {
            background: linear-gradient(45deg, #667eea, #764ba2);
            border-radius: 10px;
        }

        .table-container::-webkit-scrollbar-thumb:hover {
            background: linear-gradient(45deg, #5a6fd8, #6a4190);
        }
    </style>
</head>
<body>

    <c:if test="${empty doctObj}">
        <c:redirect url="../doctor_login.jsp"></c:redirect>
    </c:if>

    <%@include file="navbar.jsp"%>

    <div class="overlay">
        <div class="container-fluid">
            <div class="row justify-content-center">
                <div class="col-12 col-xl-11">
                    <div class="paint-card">
                        <div class="card-body">
                            <h1 class="heading">Patient Details</h1>

                            <c:if test="${not empty succMsg}">
                                <div class="alert alert-success alert-custom text-center">
                                    <i class="fas fa-check-circle me-2"></i>${succMsg}
                                </div>
                                <c:remove var="succMsg" scope="session"/>
                            </c:if>

                            <c:if test="${not empty errorMsg}">
                                <div class="alert alert-danger alert-custom text-center">
                                    <i class="fas fa-exclamation-circle me-2"></i>${errorMsg}
                                </div>
                                <c:remove var="errorMsg" scope="session"/>
                            </c:if>

                            <div class="table-container">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th><i class="fas fa-user me-2"></i>Full Name</th>
                                            <th><i class="fas fa-venus-mars me-2"></i>Gender</th>
                                            <th><i class="fas fa-birthday-cake me-2"></i>Age</th>
                                            <th><i class="fas fa-calendar me-2"></i>Appointment Date</th>
                                            <th><i class="fas fa-envelope me-2"></i>Email</th>
                                            <th><i class="fas fa-phone me-2"></i>Mobile</th>
                                            <th><i class="fas fa-stethoscope me-2"></i>Disease</th>
                                            <th><i class="fas fa-info-circle me-2"></i>Status</th>
                                            <th><i class="fas fa-cogs me-2"></i>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            Doctor d = (Doctor) session.getAttribute("doctObj");
                                            AppointmentDao dao = new AppointmentDao(DBConnect.getConn());
                                            List<Appointment> list = dao.getAllAppointmentByDoctorLogin(d.getId());
                                            for (Appointment ap : list) {
                                        %>
                                        <tr>
                                            <td><strong><%= ap.getFullName() %></strong></td>
                                            <td>
                                                <% if ("male".equalsIgnoreCase(ap.getGender())) { %>
                                                    <i class="fas fa-mars text-primary"></i> Male
                                                <% } else { %>
                                                    <i class="fas fa-venus text-danger"></i> Female
                                                <% } %>
                                            </td>
                                            <td><%= ap.getAge() %> yrs</td>
                                            <td><%= ap.getAppointDate() %></td>
                                            <td><%= ap.getEmail() %></td>
                                            <td><%= ap.getPhNo() %></td>
                                            <td><strong><%= ap.getDiseases() %></strong></td>
                                            <td>
                                                <% if ("Pending".equalsIgnoreCase(ap.getStatus())) { %>
                                                    <span class="status-pending">Pending</span>
                                                <% } else if ("Checkup done".equalsIgnoreCase(ap.getStatus()) || "Checkup Done".equalsIgnoreCase(ap.getStatus()) || "All OK".equalsIgnoreCase(ap.getStatus())) { %>
                                                    <span class="status-completed"><%= ap.getStatus() %></span>
                                                <% } else { %>
                                                    <span class="status-other"><%= ap.getStatus() %></span>
                                                <% } %>
                                            </td>
                                            <td>
                                                <% if ("Pending".equalsIgnoreCase(ap.getStatus())) { %>
                                                    <a href="comment.jsp?id=<%= ap.getId() %>" class="btn-comment">
                                                        <i class="fas fa-comment-medical me-1"></i>Comment
                                                    </a>
                                                <% } else { %>
                                                    <a href="#" class="btn-comment disabled">
                                                        <i class="fas fa-check me-1"></i>Completed
                                                    </a>
                                                <% } %>
                                            </td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
