<!DOCTYPE html>
<html>
    <head>
        <title>
        </title>
    </head>
    <body>
        <?php include 'css.php'; ?>
    </body>
</html>
<!-- Main content -->
<section class="content">
    <div class="callout callout-info">
        <h4>
            Reminder!
        </h4>
        Instructions for how to use modals are available on the
        <a href="http://getbootstrap.com/javascript/#modals">
            Bootstrap documentation
        </a>
    </div>
    <div class="row">
        <div class="col-xs-12">
            <div class="box box-default">
                <div class="box-header with-border">
                    <h3 class="box-title">
                        Modal Examples
                    </h3>
                </div>
                <div class="box-body">
                    <button class="btn btn-default" data-target="#modal-default" data-toggle="modal" type="button">
                        Launch Default Modal
                    </button>
                    <div class="modal fade" id="modal-default">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button aria-label="Close" class="close" data-dismiss="modal" type="button">
                                        <span aria-hidden="true">
                                            ×
                                        </span>
                                    </button>
                                    <h4 class="modal-title">
                                        Default Modal
                                    </h4>
                                </div>
                                <div class="modal-body">
                                    <p>
                                        One fine body…
                                    </p>
                                </div>
                                <div class="modal-footer">
                                    <button class="btn btn-default pull-left" data-dismiss="modal" type="button">
                                        Close
                                    </button>
                                    <button class="btn btn-primary" type="button">
                                        Save changes
                                    </button>
                                </div>
                            </div>
                            <!-- /.modal-content -->
                        </div>
                        <!-- /.modal-dialog -->
                    </div>
                    <!-- /.modal -->
                    <?php include 'js.php'; ?>
                </div>
            </div>
        </div>
    </div>
</section>