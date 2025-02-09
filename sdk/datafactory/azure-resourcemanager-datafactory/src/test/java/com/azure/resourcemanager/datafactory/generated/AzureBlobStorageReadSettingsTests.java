// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.
// Code generated by Microsoft (R) AutoRest Code Generator.

package com.azure.resourcemanager.datafactory.generated;

import com.azure.core.util.BinaryData;
import com.azure.resourcemanager.datafactory.models.AzureBlobStorageReadSettings;

public final class AzureBlobStorageReadSettingsTests {
    @org.junit.jupiter.api.Test
    public void testDeserialize() throws Exception {
        AzureBlobStorageReadSettings model = BinaryData.fromString(
            "{\"type\":\"AzureBlobStorageReadSettings\",\"recursive\":\"datadhlnar\",\"wildcardFolderPath\":\"datauoa\",\"wildcardFileName\":\"datairiccuyqtjvrz\",\"prefix\":\"datagmgfa\",\"fileListPath\":\"datab\",\"enablePartitionDiscovery\":\"dataaenvpzd\",\"partitionRootPath\":\"datapizgaujvc\",\"deleteFilesAfterCompletion\":\"datafybx\",\"modifiedDatetimeStart\":\"datarceomsqarbtrk\",\"modifiedDatetimeEnd\":\"dataoefi\",\"maxConcurrentConnections\":\"datajiudnus\",\"disableMetricsCollection\":\"datamoxohgkd\",\"\":{\"xzqzjv\":\"datahuepuvr\",\"wqyousqmern\":\"datarhyx\",\"memkyouwmj\":\"datajpl\",\"d\":\"datahmkch\"}}")
            .toObject(AzureBlobStorageReadSettings.class);
    }

    @org.junit.jupiter.api.Test
    public void testSerialize() throws Exception {
        AzureBlobStorageReadSettings model = new AzureBlobStorageReadSettings()
            .withMaxConcurrentConnections("datajiudnus").withDisableMetricsCollection("datamoxohgkd")
            .withRecursive("datadhlnar").withWildcardFolderPath("datauoa").withWildcardFileName("datairiccuyqtjvrz")
            .withPrefix("datagmgfa").withFileListPath("datab").withEnablePartitionDiscovery("dataaenvpzd")
            .withPartitionRootPath("datapizgaujvc").withDeleteFilesAfterCompletion("datafybx")
            .withModifiedDatetimeStart("datarceomsqarbtrk").withModifiedDatetimeEnd("dataoefi");
        model = BinaryData.fromObject(model).toObject(AzureBlobStorageReadSettings.class);
    }
}
