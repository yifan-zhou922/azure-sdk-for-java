// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.
// Code generated by Microsoft (R) AutoRest Code Generator.

package com.azure.resourcemanager.datafactory.generated;

import com.azure.core.util.BinaryData;
import com.azure.resourcemanager.datafactory.models.ScriptAction;
import org.junit.jupiter.api.Assertions;

public final class ScriptActionTests {
    @org.junit.jupiter.api.Test
    public void testDeserialize() throws Exception {
        ScriptAction model = BinaryData
            .fromString(
                "{\"name\":\"lyoix\",\"uri\":\"ei\",\"roles\":\"datanqizvsih\",\"parameters\":\"txjcajhsjuqqtzr\"}")
            .toObject(ScriptAction.class);
        Assertions.assertEquals("lyoix", model.name());
        Assertions.assertEquals("ei", model.uri());
        Assertions.assertEquals("txjcajhsjuqqtzr", model.parameters());
    }

    @org.junit.jupiter.api.Test
    public void testSerialize() throws Exception {
        ScriptAction model = new ScriptAction().withName("lyoix").withUri("ei").withRoles("datanqizvsih")
            .withParameters("txjcajhsjuqqtzr");
        model = BinaryData.fromObject(model).toObject(ScriptAction.class);
        Assertions.assertEquals("lyoix", model.name());
        Assertions.assertEquals("ei", model.uri());
        Assertions.assertEquals("txjcajhsjuqqtzr", model.parameters());
    }
}
