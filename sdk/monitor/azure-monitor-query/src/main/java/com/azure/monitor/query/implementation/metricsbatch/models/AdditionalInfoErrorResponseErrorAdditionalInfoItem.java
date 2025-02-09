// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.
// Code generated by Microsoft (R) AutoRest Code Generator.

package com.azure.monitor.query.implementation.metricsbatch.models;

import com.azure.core.annotation.Fluent;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * The AdditionalInfoErrorResponseErrorAdditionalInfoItem model.
 */
@Fluent
public final class AdditionalInfoErrorResponseErrorAdditionalInfoItem {
    /*
     * The type of the info property (e.g. string).
     */
    @JsonProperty(value = "type")
    private String type;

    /*
     * Additional information related to the error.
     */
    @JsonProperty(value = "info")
    private String info;

    /**
     * Creates an instance of AdditionalInfoErrorResponseErrorAdditionalInfoItem class.
     */
    public AdditionalInfoErrorResponseErrorAdditionalInfoItem() {
    }

    /**
     * Get the type property: The type of the info property (e.g. string).
     * 
     * @return the type value.
     */
    public String getType() {
        return this.type;
    }

    /**
     * Set the type property: The type of the info property (e.g. string).
     * 
     * @param type the type value to set.
     * @return the AdditionalInfoErrorResponseErrorAdditionalInfoItem object itself.
     */
    public AdditionalInfoErrorResponseErrorAdditionalInfoItem setType(String type) {
        this.type = type;
        return this;
    }

    /**
     * Get the info property: Additional information related to the error.
     * 
     * @return the info value.
     */
    public String getInfo() {
        return this.info;
    }

    /**
     * Set the info property: Additional information related to the error.
     * 
     * @param info the info value to set.
     * @return the AdditionalInfoErrorResponseErrorAdditionalInfoItem object itself.
     */
    public AdditionalInfoErrorResponseErrorAdditionalInfoItem setInfo(String info) {
        this.info = info;
        return this;
    }
}
