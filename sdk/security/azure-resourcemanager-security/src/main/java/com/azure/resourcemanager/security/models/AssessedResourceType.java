// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.
// Code generated by Microsoft (R) AutoRest Code Generator.

package com.azure.resourcemanager.security.models;

import com.azure.core.util.ExpandableStringEnum;
import com.fasterxml.jackson.annotation.JsonCreator;
import java.util.Collection;

/** Sub-assessment resource type. */
public final class AssessedResourceType extends ExpandableStringEnum<AssessedResourceType> {
    /** Static value SqlServerVulnerability for AssessedResourceType. */
    public static final AssessedResourceType SQL_SERVER_VULNERABILITY = fromString("SqlServerVulnerability");

    /** Static value ContainerRegistryVulnerability for AssessedResourceType. */
    public static final AssessedResourceType CONTAINER_REGISTRY_VULNERABILITY =
        fromString("ContainerRegistryVulnerability");

    /** Static value ServerVulnerability for AssessedResourceType. */
    public static final AssessedResourceType SERVER_VULNERABILITY = fromString("ServerVulnerability");

    /**
     * Creates a new instance of AssessedResourceType value.
     *
     * @deprecated Use the {@link #fromString(String)} factory method.
     */
    @Deprecated
    public AssessedResourceType() {
    }

    /**
     * Creates or finds a AssessedResourceType from its string representation.
     *
     * @param name a name to look for.
     * @return the corresponding AssessedResourceType.
     */
    @JsonCreator
    public static AssessedResourceType fromString(String name) {
        return fromString(name, AssessedResourceType.class);
    }

    /**
     * Gets known AssessedResourceType values.
     *
     * @return known AssessedResourceType values.
     */
    public static Collection<AssessedResourceType> values() {
        return values(AssessedResourceType.class);
    }
}
