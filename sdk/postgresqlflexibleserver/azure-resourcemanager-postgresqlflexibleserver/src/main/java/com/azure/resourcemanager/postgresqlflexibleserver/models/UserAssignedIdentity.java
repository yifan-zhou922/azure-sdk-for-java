// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.
// Code generated by Microsoft (R) AutoRest Code Generator.

package com.azure.resourcemanager.postgresqlflexibleserver.models;

import com.azure.core.annotation.Fluent;
import com.azure.core.util.logging.ClientLogger;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.Map;

/**
 * Information describing the identities associated with this application.
 */
@Fluent
public final class UserAssignedIdentity {
    /*
     * represents user assigned identities map.
     */
    @JsonProperty(value = "userAssignedIdentities")
    @JsonInclude(value = JsonInclude.Include.NON_NULL, content = JsonInclude.Include.ALWAYS)
    private Map<String, UserIdentity> userAssignedIdentities;

    /*
     * the types of identities associated with this resource; currently restricted to 'None and UserAssigned'
     */
    @JsonProperty(value = "type", required = true)
    private IdentityType type;

    /*
     * Tenant id of the server.
     */
    @JsonProperty(value = "tenantId", access = JsonProperty.Access.WRITE_ONLY)
    private String tenantId;

    /**
     * Creates an instance of UserAssignedIdentity class.
     */
    public UserAssignedIdentity() {
    }

    /**
     * Get the userAssignedIdentities property: represents user assigned identities map.
     * 
     * @return the userAssignedIdentities value.
     */
    public Map<String, UserIdentity> userAssignedIdentities() {
        return this.userAssignedIdentities;
    }

    /**
     * Set the userAssignedIdentities property: represents user assigned identities map.
     * 
     * @param userAssignedIdentities the userAssignedIdentities value to set.
     * @return the UserAssignedIdentity object itself.
     */
    public UserAssignedIdentity withUserAssignedIdentities(Map<String, UserIdentity> userAssignedIdentities) {
        this.userAssignedIdentities = userAssignedIdentities;
        return this;
    }

    /**
     * Get the type property: the types of identities associated with this resource; currently restricted to 'None and
     * UserAssigned'.
     * 
     * @return the type value.
     */
    public IdentityType type() {
        return this.type;
    }

    /**
     * Set the type property: the types of identities associated with this resource; currently restricted to 'None and
     * UserAssigned'.
     * 
     * @param type the type value to set.
     * @return the UserAssignedIdentity object itself.
     */
    public UserAssignedIdentity withType(IdentityType type) {
        this.type = type;
        return this;
    }

    /**
     * Get the tenantId property: Tenant id of the server.
     * 
     * @return the tenantId value.
     */
    public String tenantId() {
        return this.tenantId;
    }

    /**
     * Validates the instance.
     * 
     * @throws IllegalArgumentException thrown if the instance is not valid.
     */
    public void validate() {
        if (userAssignedIdentities() != null) {
            userAssignedIdentities().values().forEach(e -> {
                if (e != null) {
                    e.validate();
                }
            });
        }
        if (type() == null) {
            throw LOGGER.logExceptionAsError(
                new IllegalArgumentException("Missing required property type in model UserAssignedIdentity"));
        }
    }

    private static final ClientLogger LOGGER = new ClientLogger(UserAssignedIdentity.class);
}
