<%--
  Created by IntelliJ IDEA.
  User: Huy
  Date: 2016-01-06
  Time: 16:02
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">
    <meta name="keyword" content="">

    <title>添加功能页面</title>

    <jsp:include page="/WEB-INF/reuse/css.jsp"/>

    <!-- js placed at the end of the document so the pages load faster -->
    <jsp:include page="/WEB-INF/reuse/layerJs.jsp"/>
    <link href="/assets/ztree/css/demo.css" rel="stylesheet" />
    <link href="/assets/ztree/css/zTreeStyle/zTreeStyle.css" rel="stylesheet" />
    <script src="/assets/ztree/js/jquery-1.4.4.min.js"></script>
    <script src="/assets/ztree/js/jquery.ztree.core-3.5.js"></script>
    <script src="/assets/ztree/js/jquery.ztree.excheck-3.5.js"></script>
    <script src="/assets/ztree/js/jquery.ztree.exedit-3.5.js"></script>


</head>

<body>
<form id="aroleForm"> <%--action="/user/insert.htm" method="post" onsubmit="return checkForm()">--%>
    <table class="table table-bordered table-striped table-condensed">
        <tbody>

        <tr>
            <th scope="row">功能：</th>
            <td>
                <!-- 树加载后存放的容器 -->
                <ul id="treeDemo" class="ztree"></ul>
            </td>

        </tr>
        <tr>
            <input type="hidden" id="ids" name="ids" value="">
            <input type="hidden" id="rname" name="rname" value="${role.roleName}">
            <input type="hidden" id="rdesc" name="rdesc" value="${role.roleDescript}">
        </tr>

        <tr>
            <th scope="row"></th>
            <td class="text-right">
                <button id="auserBtn" type="button" class="btn btn-primary">保存</button>&nbsp;
                <button id="fileCance2" type="reset" class="btn btn-default">重置</button>&nbsp;
                <%--<button id="fileCance3" type="button" class="btn btn-default" onclick="window.location='/user/list.htm'">返回</button>--%>
            </td>
        </tr>
        </tbody>
    </table>
</form>


<script type="text/javascript">
    $(function() {
        $("#auserBtn").click(function () {
                var ids = fun();
                $("#ids").val(ids);
                if (ids == "") {
                    layer.tips('请选择权限菜单!', '#treeDemo', {tips: 4, tipsMore: true});
                    return;
                }
                var roledata = $("#aroleForm").serializeArray();
                $.ajax({
                    type: "POST",
                    url: "/role/updateOperByMenu.htm?roleId=${roleId}",
                    data: roledata,ids:ids,
                    cache: false,
                    success: function (data, status) {
                        var utip = data.roletip;
                        if (utip == 0) {
                            //$("#userError").text(reData.mes);
                            layer.tips(data.mes, '#roleName', {tips: [3, 'red'], tipsMore: true});
                        } else if (utip == 1) {
                            parent.layer.msg(status + data.mes, {shade: 0.1, time: 2000}, function () {
                                parent.window.location = "/role/list.htm";
                            });
                        } else {
                            //do nothing
                            alert("您输入的数据有误，请重新输入！");
                        }
                    },
                    error: function (xhr, status, ex) {
                        alert(status + ":保存失败!");
                    }
                });

        });
    });
    /**ztree的参数配置，setting主要是设置一些tree的属性，是本地数据源，还是远程，动画效果，是否含有复选框等等**/
    var setting = {
        check: {
            enable: true,
            chkStyle: "checkbox",
            chkboxType: {"Y": "ps", "N": "ps"}
        },
        view: {
            //dblClickExpand: false,
            expandSpeed: 300 //设置树展开的动画速度，IE6下面没效果，
        },

        async: {
            enable: true,
            type: 'post',
            url: "/role/updateOper.htm?roleId=${roleId}"
        },
        data: {
            simpleData: {   //简单的数据源，一般开发中都是从数据库里读取，API有介绍，这里只是本地的
                enable: true,
                idKey: "id",  //id和pid，这里不用多说了吧，树的目录级别
                pIdKey: "pId",
                rootPId: 0   //根节点
            }
        },
        callback: {
            /**回调函数的设置，随便写了两个**/

        }
    };

    function fun() {
        var zTree = $.fn.zTree.getZTreeObj("treeDemo");


        var checkedNodes = zTree.getCheckedNodes(true);
        var count=checkedNodes.length;
        var ids=new Array();
        for(var i=0;i<count;i=i+1){
            ids.push(checkedNodes[i].id);
        }
        ids=ids.join(",");
        return ids;
    }

    $(document).ready(function () {//初始化ztree对象
        var zTreeDemo = $.fn.zTree.init($("#treeDemo"), setting);

    });


    /*    function checkForm() {
     var userName = $("#userName").val();
     if (userName == null || userName == "") {
     $("#userError").text("用户名不能为空！");
     return false;
     }

     if (confirm("确认保存?")) {
     return true;
     } else {
     return false;
     }
     }*/
</script>

</body>
</html>
