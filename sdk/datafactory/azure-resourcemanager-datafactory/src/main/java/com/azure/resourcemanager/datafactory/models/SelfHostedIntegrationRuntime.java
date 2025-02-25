// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.
// Code generated by Microsoft (R) AutoRest Code Generator.

package com.azure.resourcemanager.datafactory.models;

import com.azure.core.annotation.Fluent;
import com.azure.resourcemanager.datafactory.fluent.models.SelfHostedIntegrationRuntimeTypeProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonTypeInfo;
import com.fasterxml.jackson.annotation.JsonTypeName;

/**
 * Self-hosted integration runtime.
 */
@JsonTypeInfo(use = JsonTypeInfo.Id.NAME, include = JsonTypeInfo.As.PROPERTY, property = "type")
@JsonTypeName("SelfHosted")
@Fluent
public final class SelfHostedIntegrationRuntime extends IntegrationRuntime {
    /*
     * When this property is not null, means this is a linked integration runtime. The property is used to access
     * original integration runtime.
     */
    @JsonProperty(value = "typeProperties")
    private SelfHostedIntegrationRuntimeTypeProperties innerTypeProperties;

    /**
     * Creates an instance of SelfHostedIntegrationRuntime class.
     */
    public SelfHostedIntegrationRuntime() {
    }

    /**
     * Get the innerTypeProperties property: When this property is not null, means this is a linked integration
     * runtime. The property is used to access original integration runtime.
     * 
     * @return the innerTypeProperties value.
     */
    private SelfHostedIntegrationRuntimeTypeProperties innerTypeProperties() {
        return this.innerTypeProperties;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public SelfHostedIntegrationRuntime withDescription(String description) {
        super.withDescription(description);
        return this;
    }

    /**
     * Get the linkedInfo property: The base definition of a linked integration runtime.
     * 
     * @return the linkedInfo value.
     */
    public LinkedIntegrationRuntimeType linkedInfo() {
        return this.innerTypeProperties() == null ? null : this.innerTypeProperties().linkedInfo();
    }

    /**
     * Set the linkedInfo property: The base definition of a linked integration runtime.
     * 
     * @param linkedInfo the linkedInfo value to set.
     * @return the SelfHostedIntegrationRuntime object itself.
     */
    public SelfHostedIntegrationRuntime withLinkedInfo(LinkedIntegrationRuntimeType linkedInfo) {
        if (this.innerTypeProperties() == null) {
            this.innerTypeProperties = new SelfHostedIntegrationRuntimeTypeProperties();
        }
        this.innerTypeProperties().withLinkedInfo(linkedInfo);
        return this;
    }

    /**
     * Get the selfContainedInteractiveAuthoringEnabled property: An alternative option to ensure interactive authoring
     * function when your self-hosted integration runtime is unable to establish a connection with Azure Relay.
     * 
     * @return the selfContainedInteractiveAuthoringEnabled value.
     */
    public Boolean selfContainedInteractiveAuthoringEnabled() {
        return this.innerTypeProperties() == null ? null
            : this.innerTypeProperties().selfContainedInteractiveAuthoringEnabled();
    }

    /**
     * Set the selfContainedInteractiveAuthoringEnabled property: An alternative option to ensure interactive authoring
     * function when your self-hosted integration runtime is unable to establish a connection with Azure Relay.
     * 
     * @param selfContainedInteractiveAuthoringEnabled the selfContainedInteractiveAuthoringEnabled value to set.
     * @return the SelfHostedIntegrationRuntime object itself.
     */
    public SelfHostedIntegrationRuntime
        withSelfContainedInteractiveAuthoringEnabled(Boolean selfContainedInteractiveAuthoringEnabled) {
        if (this.innerTypeProperties() == null) {
            this.innerTypeProperties = new SelfHostedIntegrationRuntimeTypeProperties();
        }
        this.innerTypeProperties()
            .withSelfContainedInteractiveAuthoringEnabled(selfContainedInteractiveAuthoringEnabled);
        return this;
    }

    /**
     * Validates the instance.
     * 
     * @throws IllegalArgumentException thrown if the instance is not valid.
     */
    @Override
    public void validate() {
        super.validate();
        if (innerTypeProperties() != null) {
            innerTypeProperties().validate();
        }
    }
}
