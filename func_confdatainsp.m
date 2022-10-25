function func_confdatainsp(recorddata,archivemode,runlimit)
    Simulink.sdi.setRecordData(recorddata)
    Simulink.sdi.setAutoArchiveMode(archivemode);
    Simulink.sdi.setArchiveRunLimit(runlimit);
end