// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.
// Code generated by Microsoft (R) AutoRest Code Generator.

package com.azure.resourcemanager.devcenter.generated;

/** Samples for Catalogs Connect. */
public final class CatalogsConnectSamples {
    /*
     * x-ms-original-file: specification/devcenter/resource-manager/Microsoft.DevCenter/preview/2023-10-01-preview/examples/Catalogs_Connect.json
     */
    /**
     * Sample code: Catalogs_Connect.
     *
     * @param manager Entry point to DevCenterManager.
     */
    public static void catalogsConnect(com.azure.resourcemanager.devcenter.DevCenterManager manager) {
        manager.catalogs().connect("rg1", "Contoso", "CentralCatalog", com.azure.core.util.Context.NONE);
    }
}
