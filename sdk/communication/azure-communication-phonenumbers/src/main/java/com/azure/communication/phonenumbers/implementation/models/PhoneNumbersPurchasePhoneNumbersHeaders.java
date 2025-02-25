// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.
// Code generated by Microsoft (R) AutoRest Code Generator.

package com.azure.communication.phonenumbers.implementation.models;

import com.azure.communication.phonenumbers.CodeCoverageAnnotation.Generated;
import com.azure.core.annotation.Fluent;
import com.fasterxml.jackson.annotation.JsonProperty;

/** The PhoneNumbersPurchasePhoneNumbersHeaders model. */
@Fluent
@Generated
public final class PhoneNumbersPurchasePhoneNumbersHeaders {
    /*
     * The operation-id property.
     */
    @JsonProperty(value = "operation-id")
    private String operationId;

    /*
     * The purchase-id property.
     */
    @JsonProperty(value = "purchase-id")
    private String purchaseId;

    /*
     * The Operation-Location property.
     */
    @JsonProperty(value = "Operation-Location")
    private String operationLocation;

    /**
     * Get the operationId property: The operation-id property.
     *
     * @return the operationId value.
     */
    public String getOperationId() {
        return this.operationId;
    }

    /**
     * Set the operationId property: The operation-id property.
     *
     * @param operationId the operationId value to set.
     * @return the PhoneNumbersPurchasePhoneNumbersHeaders object itself.
     */
    public PhoneNumbersPurchasePhoneNumbersHeaders setOperationId(String operationId) {
        this.operationId = operationId;
        return this;
    }

    /**
     * Get the purchaseId property: The purchase-id property.
     *
     * @return the purchaseId value.
     */
    public String getPurchaseId() {
        return this.purchaseId;
    }

    /**
     * Set the purchaseId property: The purchase-id property.
     *
     * @param purchaseId the purchaseId value to set.
     * @return the PhoneNumbersPurchasePhoneNumbersHeaders object itself.
     */
    public PhoneNumbersPurchasePhoneNumbersHeaders setPurchaseId(String purchaseId) {
        this.purchaseId = purchaseId;
        return this;
    }

    /**
     * Get the operationLocation property: The Operation-Location property.
     *
     * @return the operationLocation value.
     */
    public String getOperationLocation() {
        return this.operationLocation;
    }

    /**
     * Set the operationLocation property: The Operation-Location property.
     *
     * @param operationLocation the operationLocation value to set.
     * @return the PhoneNumbersPurchasePhoneNumbersHeaders object itself.
     */
    public PhoneNumbersPurchasePhoneNumbersHeaders setOperationLocation(String operationLocation) {
        this.operationLocation = operationLocation;
        return this;
    }
}
