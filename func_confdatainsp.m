function func_confdatainsp(archivemode,runlimit)
    Simulink.sdi.setAutoArchiveMode(archivemode);
    Simulink.sdi.setArchiveRunLimit(runlimit);
end