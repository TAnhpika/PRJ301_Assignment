<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <%@page import="java.util.List" %>
        <%@page import="java.util.ArrayList" %>
            <%@page import="java.math.BigDecimal" %>
                <%@page import="dao.MedicineDAO" %>
                    <%@page import="dao.BillDAO" %>
                        <%@page import="model.Medicine" %>
                            <%@page import="model.User" %>

<%
    String error = null;
    String success = null;
    User user = (User) session.getAttribute("user");
                                    List<Medicine> medicines = new ArrayList<>();

                                        if (user == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
                                        return;
                                        }

                                        try {
                                        MedicineDAO medicineDAO = new MedicineDAO();
                                        medicines = medicineDAO.getAllMedicine();
        if (medicines == null) medicines = new ArrayList<>();
                                            } catch (Exception e) {
                                            error = "Lỗi tải danh sách thuốc: " + e.getMessage();
                                            }
%>

                                                <!DOCTYPE html>
                                                <html lang="vi">
                                                <head>
    <%@ include file="/includes/dashboard_head.jsp" %>
                                                    <title>Bán Thuốc - Nha Khoa</title>
                                                    <style>
        .medicine-card {
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            padding: 16px;
            margin-bottom: 12px;
                                                            transition: all 0.2s;
                                                        }
        .medicine-card:hover {
            border-color: #4361ee;
            background: #f8fafc;
        }
        .cart-item {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 12px;
            margin-bottom: 8px;
        }
                                                        @media print {
            body * { visibility: hidden; }
            #billSection.show, #billSection.show * { visibility: visible; }
                                                            #billSection.show {
                                                                position: absolute;
                                                                left: 0;
                                                                top: 0;
                                                                width: 148mm;
                                                            }
                                                        }
                                                    </style>
                                                </head>
<body style="background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%); min-height: 100vh;">
    <div class="container py-4">
        <div class="row justify-content-center">
            <div class="col-lg-7">
                <div class="dashboard-card">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h5 class="mb-0"><i class="fas fa-cart-shopping me-2"></i>Bán Thuốc Trực Tiếp</h5>
                        <a href="${pageContext.request.contextPath}/jsp/staff/staff_tongquan.jsp" class="btn btn-outline-secondary btn-sm">
                            <i class="fas fa-arrow-left me-1"></i>Quay lại
                        </a>
                    </div>
                    
                    <% if (error != null) { %>
                    <div class="alert alert-danger"><i class="fas fa-exclamation-circle me-2"></i><%= error %></div>
                    <% } %>
                    
                    <form method="POST" id="sellForm" action="<%=request.getContextPath()%>/ConfirmSellMedicineServlet" onsubmit="return submitCart()">
                        <div class="mb-3">
                            <label class="form-label">Tên khách hàng (tùy chọn)</label>
                            <input type="text" name="customer_name" class="form-control" placeholder="Để trống = 'Khách lẻ'">
                        </div>
                        
                        <div class="row g-3 mb-3">
                            <div class="col-md-5">
                                <label class="form-label">Chọn thuốc <span class="text-danger">*</span></label>
                                <select name="medicine_id" id="medicineSelect" class="form-select" required>
                                                                            <option value="">-- Chọn thuốc --</option>
                                                                            <% for (Medicine medicine : medicines) { %>
                                    <option value="<%= medicine.getMedicineId() %>"
                                                                                    data-name="<%= medicine.getName() %>"
                                                                                    data-unit="<%= medicine.getUnit() != null ? medicine.getUnit() : "viên" %>"
                                            data-price="<%= medicine.getPrice() != null ? medicine.getPrice().intValue() : 0 %>">
                                        <%= medicine.getName() %> - Còn: <%= medicine.getQuantityInStock() %> <%= medicine.getUnit() != null ? medicine.getUnit() : "viên" %>
                                                                                </option>
                                                                                <% } %>
                                                                        </select>
                                                                    </div>
                            <div class="col-md-2">
                                <label class="form-label">Số lượng <span class="text-danger">*</span></label>
                                <input type="number" id="quantityInput" min="1" class="form-control" placeholder="SL">
                            </div>
                            <div class="col-md-2">
                                <label class="form-label">Đơn giá</label>
                                <input type="text" id="priceDisplay" class="form-control" readonly>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Thành tiền</label>
                                <input type="text" id="totalDisplay" class="form-control" readonly>
                            </div>
                        </div>
                        
                        <button type="button" class="btn btn-outline-primary mb-4" onclick="addToCart()">
                            <i class="fas fa-plus me-1"></i>Thêm vào hóa đơn
                        </button>
                        
                        <input type="hidden" name="cart_json" id="cartJsonInput">
                        
                        <!-- Cart Section -->
                        <div class="mb-4">
                            <h6><i class="fas fa-shopping-cart me-2"></i>Giỏ hàng</h6>
                            <div id="cartList">
                                <div class="text-center py-3 text-muted">
                                    <i class="fas fa-cart-plus"></i> Chưa có thuốc nào
                                </div>
                                                                    </div>
                            <div class="stat-card success mt-3" style="padding: 15px;">
                                <div class="text-center">
                                    <strong>Tổng tiền: </strong>
                                    <span id="cartTotal" class="fs-5">0 VNĐ</span>
                                                                    </div>
                                                                    </div>
                                                                </div>
                        
                        <div class="mb-4">
                            <label class="form-label">Phương thức thanh toán</label>
                            <div class="d-flex gap-3">
                                <div class="form-check">
                                    <input type="radio" name="payment_method" value="cash" checked class="form-check-input" id="cashMethod">
                                    <label class="form-check-label" for="cashMethod"><i class="fas fa-money-bill me-1"></i>Tiền mặt</label>
                                </div>
                                <div class="form-check">
                                    <input type="radio" name="payment_method" value="payos" class="form-check-input" id="payosMethod">
                                    <label class="form-check-label" for="payosMethod"><i class="fas fa-qrcode me-1"></i>QR PayOS</label>
                                </div>
                                                                </div>
                                                                </div>
                        
                        <button type="submit" class="btn-dashboard btn-dashboard-primary w-100">
                            <i class="fas fa-receipt me-2"></i>Tạo & In Hóa Đơn
                        </button>
                                                            </form>
                                                        </div>
            </div>
            
            <!-- Medicine List -->
            <div class="col-lg-4">
                <div class="dashboard-card">
                    <h6 class="mb-3"><i class="fas fa-pills me-2"></i>Danh sách thuốc</h6>
                    <div style="max-height: 500px; overflow-y: auto;">
                        <% for (Medicine medicine : medicines) { 
                            String unit = medicine.getUnit() != null ? medicine.getUnit() : "viên";
                            String price = medicine.getPrice() != null ? String.format("%,d", medicine.getPrice().intValue()) : "0";
                        %>
                                                                        <div class="medicine-card">
                            <h6 class="mb-1"><%= medicine.getName() %></h6>
                            <small class="text-muted">Đơn vị: <%= unit %></small><br>
                            <small class="text-muted">Tồn kho: <%= medicine.getQuantityInStock() %></small><br>
                            <strong class="text-success"><%= price %> VNĐ</strong>
                            <% if (medicine.getDescription() != null && !medicine.getDescription().trim().isEmpty()) { %>
                            <p class="text-muted small mt-1 mb-0"><%= medicine.getDescription() %></p>
                                                                                <% } %>
                                                                        </div>
                                                                        <% } %>
                                                        </div>
                                                    </div>
            </div>
        </div>
                                                    </div>
    
    <%@ include file="/includes/dashboard_scripts.jsp" %>
    
                                                            <script>
                                                                const medicineSelect = document.getElementById('medicineSelect');
                                                                const quantityInput = document.getElementById('quantityInput');
                                                                const priceDisplay = document.getElementById('priceDisplay');
                                                                const totalDisplay = document.getElementById('totalDisplay');
                                                                let cartItems = [];

                                                                function updatePriceAndTotal() {
                                                                    const selectedOption = medicineSelect.options[medicineSelect.selectedIndex];
                                                                    const price = parseInt(selectedOption.getAttribute('data-price')) || 0;
                                                                    const quantity = parseInt(quantityInput.value) || 0;
                                                                    priceDisplay.value = price.toLocaleString('vi-VN');
                                                                    totalDisplay.value = (price * quantity).toLocaleString('vi-VN');
                                                                }
        
                                                                medicineSelect.addEventListener('change', updatePriceAndTotal);
                                                                quantityInput.addEventListener('input', updatePriceAndTotal);

                                                                function addToCart() {
                                                                    const selectedOption = medicineSelect.options[medicineSelect.selectedIndex];
                                                                    const medicineId = selectedOption.value;
                                                                    const name = selectedOption.getAttribute('data-name');
                                                                    const unit = selectedOption.getAttribute('data-unit');
                                                                    const price = parseInt(selectedOption.getAttribute('data-price')) || 0;
                                                                    const quantity = parseInt(quantityInput.value) || 0;
            
                                                                    if (!medicineId || quantity <= 0) {
                                                                        alert('Vui lòng chọn thuốc và nhập số lượng hợp lệ!');
                                                                        return;
                                                                    }
            
                                                                    const existing = cartItems.find(item => item.medicineId === medicineId);
                                                                    if (existing) {
                                                                        existing.quantity += quantity;
                                                                    } else {
                                                                        cartItems.push({ medicineId, name, unit, price, quantity });
                                                                    }
                                                                    renderCart();
            quantityInput.value = '';
                                                                    updatePriceAndTotal();
                                                                }

                                                                function removeFromCart(idx) {
                                                                    cartItems.splice(idx, 1);
                                                                    renderCart();
                                                                }

                                                                function renderCart() {
                                                                    const cartList = document.getElementById('cartList');
                                                                    const cartTotal = document.getElementById('cartTotal');
            
                                                                    if (cartItems.length === 0) {
                cartList.innerHTML = '<div class="text-center py-3 text-muted"><i class="fas fa-cart-plus"></i> Chưa có thuốc nào</div>';
                cartTotal.textContent = '0 VNĐ';
                                                                        return;
                                                                    }
            
                                                                    let html = '';
                                                                    let total = 0;
            
                                                                    cartItems.forEach((item, idx) => {
                                                                        const itemTotal = item.price * item.quantity;
                                                                        total += itemTotal;
                html += `<div class="cart-item d-flex justify-content-between align-items-center">
                    <div>
                        <strong>${item.name}</strong><br>
                        <small>${item.quantity} ${item.unit} × ${item.price.toLocaleString('vi-VN')} VNĐ</small>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <strong class="text-success">${itemTotal.toLocaleString('vi-VN')} VNĐ</strong>
                        <button type="button" class="btn btn-sm btn-danger" onclick="removeFromCart(${idx})"><i class="fas fa-times"></i></button>
                    </div>
                                                                        </div>`;
                                                                    });
            
                                                                    cartList.innerHTML = html;
            cartTotal.textContent = total.toLocaleString('vi-VN') + ' VNĐ';
                                                                }

                                                                function submitCart() {
                                                                    if (cartItems.length === 0) {
                                                                        alert('Vui lòng thêm ít nhất 1 thuốc vào hóa đơn!');
                                                                        return false;
                                                                    }
                                                                    document.getElementById('cartJsonInput').value = JSON.stringify(cartItems);
                                                                    return true;
                                                                }
                                                            </script>
                                                </body>
                                                </html>
