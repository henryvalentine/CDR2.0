import * as React from "react";

class TableFooter extends React.Component {
  render() {
    const { dataSource, columns } = this.props;
    return (
      <table className="ant-table">
        <colgroup>
          {columns.map((colModel, index) => {
            return <col style={{
              width: colModel.width,
              minWidth: colModel.width
            }} key={index} />
          })}
        </colgroup>
        <tfoot >
          <tr >
            {columns.map((colum, idxCol) => {
              return <td style={{ padding: "0px 8px" }} className={colum.className} key={idxCol}>
                <strong>
                    {
                       colum.footerContent + String(dataSource.reduce((sum, record) => sum + parseFloat(record[colum.key]), 0)).replace(/(.)(?=(\d{3})+$)/g, '$1,') 
                  }
                </strong>
              </td>
            })}
          </tr>
        </tfoot>
      </table>
    )
  }
}
export default TableFooter;