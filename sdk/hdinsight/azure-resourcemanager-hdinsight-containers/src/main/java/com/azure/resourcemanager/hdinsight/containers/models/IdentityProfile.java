// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.
// Code generated by Microsoft (R) AutoRest Code Generator.

package com.azure.resourcemanager.hdinsight.containers.models;

import com.azure.core.annotation.Fluent;
import com.azure.core.util.logging.ClientLogger;
import com.fasterxml.jackson.annotation.JsonProperty;

/** Identity Profile with details of an MSI. */
@Fluent
public class IdentityProfile {
    /*
     * ResourceId of the MSI.
     */
    @JsonProperty(value = "msiResourceId", required = true)
    private String msiResourceId;

    /*
     * ClientId of the MSI.
     */
    @JsonProperty(value = "msiClientId", required = true)
    private String msiClientId;

    /*
     * ObjectId of the MSI.
     */
    @JsonProperty(value = "msiObjectId", required = true)
    private String msiObjectId;

    /** Creates an instance of IdentityProfile class. */
    public IdentityProfile() {
    }

    /**
     * Get the msiResourceId property: ResourceId of the MSI.
     *
     * @return the msiResourceId value.
     */
    public String msiResourceId() {
        return this.msiResourceId;
    }

    /**
     * Set the msiResourceId property: ResourceId of the MSI.
     *
     * @param msiResourceId the msiResourceId value to set.
     * @return the IdentityProfile object itself.
     */
    public IdentityProfile withMsiResourceId(String msiResourceId) {
        this.msiResourceId = msiResourceId;
        return this;
    }

    /**
     * Get the msiClientId property: ClientId of the MSI.
     *
     * @return the msiClientId value.
     */
    public String msiClientId() {
        return this.msiClientId;
    }

    /**
     * Set the msiClientId property: ClientId of the MSI.
     *
     * @param msiClientId the msiClientId value to set.
     * @return the IdentityProfile object itself.
     */
    public IdentityProfile withMsiClientId(String msiClientId) {
        this.msiClientId = msiClientId;
        return this;
    }

    /**
     * Get the msiObjectId property: ObjectId of the MSI.
     *
     * @return the msiObjectId value.
     */
    public String msiObjectId() {
        return this.msiObjectId;
    }

    /**
     * Set the msiObjectId property: ObjectId of the MSI.
     *
     * @param msiObjectId the msiObjectId value to set.
     * @return the IdentityProfile object itself.
     */
    public IdentityProfile withMsiObjectId(String msiObjectId) {
        this.msiObjectId = msiObjectId;
        return this;
    }

    /**
     * Validates the instance.
     *
     * @throws IllegalArgumentException thrown if the instance is not valid.
     */
    public void validate() {
        if (msiResourceId() == null) {
            throw LOGGER
                .logExceptionAsError(
                    new IllegalArgumentException("Missing required property msiResourceId in model IdentityProfile"));
        }
        if (msiClientId() == null) {
            throw LOGGER
                .logExceptionAsError(
                    new IllegalArgumentException("Missing required property msiClientId in model IdentityProfile"));
        }
        if (msiObjectId() == null) {
            throw LOGGER
                .logExceptionAsError(
                    new IllegalArgumentException("Missing required property msiObjectId in model IdentityProfile"));
        }
    }

    private static final ClientLogger LOGGER = new ClientLogger(IdentityProfile.class);
}
