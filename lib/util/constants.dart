import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

// Prod Url
const String findingServiceUrl = 'https://svcs.ebay.com/services/search/FindingService/v1';

// Header Keys
const String appNameHeader = 'X-EBAY-SOA-SECURITY-APPNAME';
const String operationNameHeader = 'X-EBAY-SOA-OPERATION-NAME';
const String serviceVersionHeader = 'X-EBAY-SOA-SERVICE-VERSION';
const String globalIdHeader = 'X-EBAY-SOA-GLOBAL-ID';
const String serviceNameHeader = 'X-EBAY-SOA-SERVICE-NAME';
const String requestDataFormatHeader = 'X-EBAY-SOA-REQUEST-DATA-FORMAT';
const String responseDataFormatHeader = 'X-EBAY-SOA-RESPONSE-DATA-FORMAT';

// Header Values
const String findCompletedItems = 'findCompletedItems';
const String findItemsByKeywords = 'findItemsByKeywords';
const String findItemsByProduct = 'findItemsByProduct';
const String serviceVersionHeaderValue = '1.0.0';
const String globalIdHeaderValue = 'EBAY-US';
const String serviceNameHeaderValue = 'FindingService';
const String json = 'JSON';
const String xml = 'XML';

// Request Headers
Map<String, String> completedItemsHeaders = {
  HttpHeaders.contentTypeHeader: 'application/json',
  appNameHeader: DotEnv().env['APP_ID'],
  operationNameHeader: findCompletedItems,
  serviceVersionHeader: serviceVersionHeaderValue,
  globalIdHeader: globalIdHeaderValue,
  serviceNameHeader: serviceNameHeaderValue,
  requestDataFormatHeader: json,
  responseDataFormatHeader: json
};

Map<String, String> activeItemsHeaders = {
  HttpHeaders.contentTypeHeader: 'application/json',
  appNameHeader: DotEnv().env['APP_ID'],
  operationNameHeader: findItemsByKeywords,
  serviceVersionHeader: serviceVersionHeaderValue,
  globalIdHeader: globalIdHeaderValue,
  serviceNameHeader: serviceNameHeaderValue,
  requestDataFormatHeader: json,
  responseDataFormatHeader: json
};

// Ebay Item Conditions
const Map<String, String> conditionsMap = {
  'New': '1000',
  'New or other': '1500',
  'New with defects': '1750',
  'Manufacturer refurbished': '2000',
  'Seller refurbished': '2500',
  'Used' : '3000',
  'Very Good' : '4000',
  'Good' : '5000',
  'Acceptable' : '6000',
  'For parts or not working': '7000'
};

// Ebay Regions
const Map<String, String> regionsMap = {
  'Austria' : 'EBAY-AT',
  'Australia' : 'EBAY-AU',
  'Switzerland' : 'EBAY-CH',
  'Germany' : 'EBAY-DE',
  'Canada (English)' : 'EBAY-ENCA',
  'Spain' : 'EBAY-ES',
  'France' : 'EBAY-FR',
  'Belgium (French)' : 'EBAY-FRBE',
  'Canada (French)' : 'EBAY-FRCA',
  'UK' : 'EBAY-GB',
  'Hong Kong' : 'EBAY-HK',
  'Ireland' : 'EBAY-IE',
  'India' : 'EBAY-IN',
  'Italy' : 'EBAY-IT',
  'Motors' : 'EBAY-MOTOR',
  'Malaysia' : 'EBAY-MY',
  'Netherlands' : 'EBAY-NL',
  'Belgium (Dutch)' : 'EBAY-NLBE',
  'Philippines' : 'EBAY-PH',
  'Poland' : 'EBAY-PL',
  'Singapore' : 'EBAY-SG',
  'United States' : 'EBAY-US'
};

// Json Request Constants
const String keywords = 'keywords';
const String itemFilter = 'itemFilter';
const String nameKey = 'name';
const String condition = 'Condition';
const String soldItemsOnly = 'SoldItemsOnly';
const String hideDuplicateItems = 'HideDuplicateItems';
const String valueKey = 'value';
const String sortOrder = 'sortOrder';
const String bestMatch = 'BestMatch';
const String trueString = 'true';
const String falseString = 'false';
const String paginationInput = 'paginationInput';
const String entriesPerPage = 'entriesPerPage';
const String pageNumber = 'pageNumber';
const String twentyFive = '25';
const String oneHundred = '100';
const String one = '1';

// Json Response Constants
const String findItemsByKeywordsResponse = 'findItemsByKeywordsResponse';
const String findCompletedItemsResponse = 'findCompletedItemsResponse';
const String searchResult = 'searchResult';
const String item = 'item';
const String paginationOutput = 'paginationOutput';
const String totalEntries = 'totalEntries';
const String errorMessage = 'errorMessage';
const String error = 'error';
const String message = 'message';

// Item Class - Constants
const String itemId = "itemId";
const String titleKey = "title";
const String globalIdKey = "globalId";
const String galleryUrlKey = "galleryURL";
const String viewItemUrlKey = "viewItemURL";
const String locationKey = "location";
const String countryKey = "country";
const String sellingStatusKey = "sellingStatus";
const String sellingStateKey = "sellingState";
const String currentPriceKey = "currentPrice";
const String underscoreValueKey = "__value__";
const String notAvailable = "N/A";
const String ended = "Ended";
const String endedWithSales = "EndedWithSales";
const String active = "Active";

// Selector Constants
const String usedValue = "Used";
const String veryGoodValue = "Very Good";
const String goodValue = "Good";
const String acceptableValue = "Acceptable";

const String newValue = "New";
const String newOrOtherValue = "New or other";

// Product Type
const String upc = "UPC";
const String isbn = "ISBN";