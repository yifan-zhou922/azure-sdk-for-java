// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.
// Code generated by Microsoft (R) TypeSpec Code Generator.
package com.azure.health.insights.radiologyinsights.models;

import com.azure.core.annotation.Fluent;
import com.azure.core.annotation.Generated;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.List;

/**
 * Document administrative metadata.
 */
@Fluent
public final class DocumentAdministrativeMetadata {

    /*
     * List of procedure information associated with the document.
     */
    @Generated
    @JsonProperty(value = "orderedProcedures")
    private List<FhirR4Extendible> orderedProcedures;

    /*
     * Reference to the encounter associated with the document.
     */
    @Generated
    @JsonProperty(value = "encounterId")
    private String encounterId;

    /**
     * Creates an instance of DocumentAdministrativeMetadata class.
     */
    @Generated
    public DocumentAdministrativeMetadata() {
    }

    /**
     * Get the orderedProcedures property: List of procedure information associated with the document.
     *
     * @return the orderedProcedures value.
     */
    @Generated
    public List<FhirR4Extendible> getOrderedProcedures() {
        return this.orderedProcedures;
    }

    /**
     * Set the orderedProcedures property: List of procedure information associated with the document.
     *
     * @param orderedProcedures the orderedProcedures value to set.
     * @return the DocumentAdministrativeMetadata object itself.
     */
    @Generated
    public DocumentAdministrativeMetadata setOrderedProcedures(List<FhirR4Extendible> orderedProcedures) {
        this.orderedProcedures = orderedProcedures;
        return this;
    }

    /**
     * Get the encounterId property: Reference to the encounter associated with the document.
     *
     * @return the encounterId value.
     */
    @Generated
    public String getEncounterId() {
        return this.encounterId;
    }

    /**
     * Set the encounterId property: Reference to the encounter associated with the document.
     *
     * @param encounterId the encounterId value to set.
     * @return the DocumentAdministrativeMetadata object itself.
     */
    @Generated
    public DocumentAdministrativeMetadata setEncounterId(String encounterId) {
        this.encounterId = encounterId;
        return this;
    }
}
