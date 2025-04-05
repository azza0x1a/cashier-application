class Api {
  /// Release
  /*static const baseURL = "https://www.ciptapro.com/mozaic";*/
  /// Demo
  static const baseURL = "https://www.ciptapro.com/mozaic-demo";
  /// Local network
  /*static const baseURL = "http://192.168.1.31:8080";*/

  /// Auth
  static const api = "/api/";
  static const register = "${baseURL+api}register";
  static const loginState = "${baseURL+api}login-state";
  static const login = "${baseURL+api}login";
  static const logout = "${baseURL+api}logout";
  static const changePassword = "${baseURL+api}change-password";

  /// Company
  static const preferenceCompany = "${baseURL+api}preference-company";

  /// Sales Pay & Save
  static const salesAdd = "${baseURL+api}sales-recipe/add";
  static const insertSalesSave = "${baseURL+api}sales-recipe/save";
  static const salesSavedPay = "${baseURL+api}sales/saved/pay";

  /// Sales Saved Item
  static const salesSaved = "${baseURL+api}sales/saved";

  /// Sales Unpaid, Paid, Sales List
  static const salesPaid = "${baseURL+api}sales-list-today/paid";
  static const salesPaidMenu = "${baseURL+api}sales-list-today/paid/menu";
  static const salesUnpaid = "${baseURL+api}sales-list-today/unpaid";

  /// Item & Category
  static const item = "${baseURL+api}item";
  static const itemAdd = "${baseURL+api}item/add";
  static const itemCategory = "${baseURL+api}item-category";
  static const itemCategoryAdd = "${baseURL+api}item-category/add";
  static const itemCategoryNewMenu = "${baseURL+api}item-new-menu";
  static const itemDetail = "${baseURL+api}item-detail";
  static const itemUnit = "${baseURL+api}item-unit";
  static const itemUnitAdd = "${baseURL+api}item-unit/add";
  static const itemUpdate = "${baseURL+api}item/update";
  static const itemAll = "${baseURL+api}item-all";

  /// Expenditure
  static const expenditure = "${baseURL+api}expenditure";
  static const expenditureGetAccount = "${baseURL+api}expenditure/get-account";
  static const expenditureToday = "${baseURL+api}expenditure-today";

  /// Dashboard
  static const dashboard = "${baseURL+api}dashboard";

  /// Capital Money
  static const capitalMoney = "${baseURL+api}capital-money";

  /// Printer settings
  static const printerAddress = "${baseURL+api}printer-address";
  static const printerUpdate = "${baseURL+api}printer-address/update";
  static const printerKitchenAddress = "${baseURL+api}printer-kitchen-address";
  static const printerKitchenUpdate = "${baseURL+api}printer-kitchen-address/update";

  /// Printer actions
  static const salesPrint = "${baseURL+api}sales/print";
  static const expenditurePrint = "${baseURL+api}expenditure/print";
  static const dashboardPrint = "${baseURL+api}dashboard/print";
}