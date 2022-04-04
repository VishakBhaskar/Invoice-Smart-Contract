// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract InvoiceData {
    struct Invoice {
        uint invoiceNumber;
        string buyerPAN;
        string sellerPAN;
        uint amount;
        uint date;
        bool paymentStatus;
        address payable sellerAddress;
    }

    mapping(string => Invoice[]) private invoicesByBuyer;
    mapping(uint => Invoice) private allInvoices;

    function createInvoice(string memory _buyerPAN, string memory _sellerPAN, uint _amount, uint dateDDMMYY, bool _paymentStatus, address payable _sellerAddress) public {
        invoicesByBuyer[_buyerPAN].push(Invoice({
            invoiceNumber : block.timestamp,
            buyerPAN : _buyerPAN, 
            sellerPAN : _sellerPAN, 
            amount : _amount,
            date : dateDDMMYY,
            paymentStatus : _paymentStatus,
            sellerAddress : _sellerAddress}));

        allInvoices[block.timestamp] = Invoice({
            invoiceNumber : block.timestamp,
            buyerPAN : _buyerPAN, 
            sellerPAN : _sellerPAN, 
            amount : _amount,
            date : dateDDMMYY,
            paymentStatus : _paymentStatus,
            sellerAddress : _sellerAddress});
    }

    function pay(uint _invoiceNumber) public payable {
        require(allInvoices[_invoiceNumber].paymentStatus == false , "Invoice already paid");
        uint invoiceAmount = allInvoices[_invoiceNumber].amount;
        address payable _toAddress = allInvoices[_invoiceNumber].sellerAddress;
        _toAddress.transfer(invoiceAmount);
        allInvoices[_invoiceNumber].paymentStatus = true;
    }

    function getPaymentStatus(uint _invoiceNumber) public view returns(string memory) {
        if(allInvoices[_invoiceNumber].paymentStatus == true) {
            return ("Invoice Paid");
        }
        else {
            return ("Invoice not paid");
        }
    }
 
    function getInvoicesByBuyer(string memory _buyerPAN) public view returns(Invoice[] memory) {
        return(invoicesByBuyer[_buyerPAN]);
    }
}
