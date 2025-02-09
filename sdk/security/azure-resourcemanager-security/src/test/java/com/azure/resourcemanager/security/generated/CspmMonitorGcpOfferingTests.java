// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.
// Code generated by Microsoft (R) AutoRest Code Generator.

package com.azure.resourcemanager.security.generated;

import com.azure.core.util.BinaryData;
import com.azure.resourcemanager.security.models.CspmMonitorGcpOffering;
import com.azure.resourcemanager.security.models.CspmMonitorGcpOfferingNativeCloudConnection;
import org.junit.jupiter.api.Assertions;

public final class CspmMonitorGcpOfferingTests {
    @org.junit.jupiter.api.Test
    public void testDeserialize() throws Exception {
        CspmMonitorGcpOffering model =
            BinaryData
                .fromString(
                    "{\"offeringType\":\"CspmMonitorGcp\",\"nativeCloudConnection\":{\"workloadIdentityProviderId\":\"nqimwbzxpdcldp\",\"serviceAccountEmailAddress\":\"wnsnlaimouxwks\"},\"description\":\"udmfcoibiczius\"}")
                .toObject(CspmMonitorGcpOffering.class);
        Assertions.assertEquals("nqimwbzxpdcldp", model.nativeCloudConnection().workloadIdentityProviderId());
        Assertions.assertEquals("wnsnlaimouxwks", model.nativeCloudConnection().serviceAccountEmailAddress());
    }

    @org.junit.jupiter.api.Test
    public void testSerialize() throws Exception {
        CspmMonitorGcpOffering model =
            new CspmMonitorGcpOffering()
                .withNativeCloudConnection(
                    new CspmMonitorGcpOfferingNativeCloudConnection()
                        .withWorkloadIdentityProviderId("nqimwbzxpdcldp")
                        .withServiceAccountEmailAddress("wnsnlaimouxwks"));
        model = BinaryData.fromObject(model).toObject(CspmMonitorGcpOffering.class);
        Assertions.assertEquals("nqimwbzxpdcldp", model.nativeCloudConnection().workloadIdentityProviderId());
        Assertions.assertEquals("wnsnlaimouxwks", model.nativeCloudConnection().serviceAccountEmailAddress());
    }
}
