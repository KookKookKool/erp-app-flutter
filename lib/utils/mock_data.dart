// lib/utils/mock_data.dart

/// Mock Data สำหรับทั้งระบบ (นำไปใช้ได้ทุกหน้า)

/// =========== PRODUCT =============
List<Map<String, dynamic>> mockProductList = [
  {"code": "P001", "name": "สมุดโน๊ต A5", "qty": 50, "unit": "เล่ม", "min": 10},
  {"code": "P002", "name": "ปากกาเจล", "qty": 100, "unit": "ด้าม", "min": 20},
  {"code": "P003", "name": "น้ำดื่ม", "qty": 30, "unit": "ขวด", "min": 5},
];

/// =========== PURCHASE ORDER =============
List<Map<String, dynamic>> mockPOList = [
  {
    "poNo": "PO-240001",
    "date": "2024-06-20",
    "supplier": "บริษัท สมาร์ทซัพพลาย จำกัด",
    "warehouse": "คลังหลัก",
    "status": "อนุมัติ",
    "items": [
      {
        "code": "P001",
        "name": "สมุดโน๊ต A5",
        "qty": 10,
        "unit": "เล่ม",
        "received": 5,
      },
      {
        "code": "P002",
        "name": "ปากกาเจล",
        "qty": 20,
        "unit": "ด้าม",
        "received": 10,
      },
    ],
  },
  {
    "poNo": "PO-240002",
    "date": "2024-06-18",
    "supplier": "รุ่งเรืองการค้า",
    "warehouse": "คลังสาขา 1",
    "status": "รับบางส่วน",
    "items": [
      {
        "code": "P003",
        "name": "น้ำดื่ม",
        "qty": 50,
        "unit": "ขวด",
        "received": 30,
      },
    ],
  },
  {
    "poNo": "PO-240003",
    "date": "2024-06-17",
    "supplier": "รุ่งโรจน์การค้า",
    "warehouse": "คลังหลัก",
    "status": "รับครบ",
    "items": [
      {
        "code": "P004",
        "name": "ไม้บรรทัด",
        "qty": 10,
        "unit": "อัน",
        "received": 10,
      },
    ],
  },
  {
    "poNo": "PO-240004",
    "date": "2024-06-20",
    "supplier": "บริษัท สมาร์ทซัพพลาย จำกัด",
    "warehouse": "คลังหลัก",
    "status": "อนุมัติ",
    "items": [
      {
        "code": "P001",
        "name": "สมุดโน๊ต A4",
        "qty": 10,
        "unit": "เล่ม",
        "received": 5,
      },
      {
        "code": "P002",
        "name": "ดินสอ",
        "qty": 20,
        "unit": "ด้าม",
        "received": 10,
      },
    ],
  },
];

/// =========== SUPPLIER =============
List<Map<String, dynamic>> mockSupplierList = [
  {
    "code": "S001",
    "name": "บริษัท สมาร์ทซัพพลาย จำกัด",
    "phone": "086-111-2222",
    "email": "contact@smartsupply.co.th",
    "address": "12/34 ถ.สุขุมวิท บางนา กทม.",
    "remark": "VAT Registered",
  },
  {
    "code": "S002",
    "name": "รุ่งเรืองการค้า",
    "phone": "098-222-3333",
    "email": "rung@example.com",
    "address": "89/9 หมู่ 7 เชียงใหม่",
    "remark": "",
  },
  {
    "code": "S003",
    "name": "รุ่งโรจน์การค้า",
    "phone": "098-222-444",
    "email": "rungroj@example.com",
    "address": "109/9 หมู่ 8 เชียงราย",
    "remark": "",
  },
];

/// =========== WAREHOUSE (โกดัง) =============
List<Map<String, dynamic>> mockWarehouseList = [
  {
    "code": "W001",
    "name": "คลังหลัก",
    "location": "สำนักงานใหญ่",
    "remark": "คลังสินค้าหลักสำหรับบริษัท",
  },
  {"code": "W002", "name": "คลังสาขา 1", "location": "บางนา", "remark": ""},
  {"code": "W003", "name": "คลังสาขา 2", "location": "บางกรวย", "remark": ""},
];

/// =========== RECEIVING (ประวัติรับเข้า) =============
List<Map<String, dynamic>> mockReceivingList = [
  // สามารถเพิ่มข้อมูลรับเข้าตามต้องการ
];

List<Map<String, dynamic>> mockMovementList = [
   {
     "date": "2024-06-19",
     "type": "IN", // "OUT", "TRANSFER"
     "product": "P001",
     "productName": "สมุดโน๊ต A5",
     "qty": 10,
     "warehouse": "คลังหลัก",
     "remark": "รับเข้า",
   },
];

